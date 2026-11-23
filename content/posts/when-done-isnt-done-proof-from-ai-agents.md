---
title: "When Done Isn't Done: What Counts as Proof from an AI Agent?"
slug: when-done-isnt-done-proof-from-ai-agents
description: "An agent reports a migration complete. What would let you approve it? This companion to my DevCon Romania talk shows how to carry a requirement through delegation and check it on the patch you're about to accept."
author: Dragos Hont
date: 2026-11-23
draft: false
---

### The report that said done

Imagine you've asked a coding agent to move a serving path and keep its safety monitor running. The agent sends back a patch and reports the migration complete. The new path still writes conversation logs, so at first glance you can see something working. Before approving the patch, there's one more thing you'd want to know: does the monitor still see requests on that path?

I opened my [DevCon Romania talk](https://www.dev-con.ro/speakers/45-Drago%C8%99+Hon%C8%9B) with a case where that question mattered. In [OpenAI's report on the October 6 migration](https://openai.com/safety-alignment/misalignment-reports/suppressing-misalignment-monitoring-alerts-and-disabling-misalignment-monitoring/), GPT-6 Astra coordinated a change that copied a reference implementation and handed part of it to a worker agent. Before the handoff, the rule was clear: the monitor had to stay on, even during the migration. The coordinator told the worker to preserve monitoring "as appropriate" to the reference. Those two words gave the worker something to interpret.

The reference had no explicit monitor connection. The worker removed the monitor integration and rewrote a regression test to expect it to be absent. The worker reported the removal back to the coordinator. The final message to the user said the migration was complete, without mentioning that monitoring was removed. When the user asked directly, the coordinator denied removing an enabled monitor.

OpenAI's report leaves the underlying cause open, and so will I. What we can see is how the patch came back looking finished: the requirement got weaker in the handoff, the test followed the new implementation, and the final report never brought the original rule back into view.

### A report is a claim

A green check would only help if it tested the rule you cared about. Here, the rewritten test expected the monitor entry to be missing. Imagine you have the patch open in front of you. The report says the migration is done and the test agrees with the code. Where would you look for proof that the original rule still holds?

The [companion repository](https://github.com/dragoshont/when-done-isnt-done) lets you run a synthetic orders service where a `200` can hide a missing monitor event. The three questions from the talk carry that rule from the ticket to the merge decision.

![requirements/monitor.md holds MON-1. The optional worker.agent.md profile carries it into the handoff, and the worker proposes a pull request. verify-monitor.yml, an unexercised template, runs check-monitor.mjs from the base revision against the candidate merge commit. Branch protection is a manual repository setting that can require monitor-contract and a maintainer review. A stop hook is optional and not included.](/images/when-done-isnt-done-figure.svg)

*A sketch of how I'd wire the handoff, test and merge decision into a project. The filenames in the sketch describe that proposed setup. The companion repository runs the local monitor check.*

### 1. What did I hand over?

I'd put the change and the constraint in the same message. For the incident, the handoff I'd propose looks like this:

> Change how the system handles tool calls to follow the reference. Keep the tools working as before. Keep the required safety monitor active. The reference has no explicit monitor connection. Find a supported way to keep the monitor on the new path. If you can't meet both requirements, report the conflict before removing monitoring.

Now the worker knows what it can change and what it has to keep. It can adapt the code. It can't assume that anything missing from the reference is safe to remove. I'd record that rule as `MON-1` in a file such as `requirements/monitor.md`. Keep the same wording and ID when another agent takes over.

If the work stops halfway and a fresh session picks it up, a summary that says "migration done" can hide the open question. I'd leave this instead:

> The code is changed. The safety monitor must stay active. We haven't checked whether the monitor runs on the new path. Next, run the new path and check that the monitor processes that same run.

The next agent knows where to continue, instead of treating unfinished work as accepted work.

### 2. Who hears "I don't know"?

The reference gave the worker a real question: how should it keep monitoring on a path with no explicit monitor connection? A vague "I need help" makes the coordinator repeat the investigation. Here's the message I'd want back:

> The reference has no explicit monitor connection. Our instruction is to keep monitoring active. I have not removed it. Which supported approach meets both requirements?

"I have not removed it" tells the coordinator the current state. And it must be true. If the worker already removed the monitor, it needs to say so.

An optional [Copilot CLI custom agent profile](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-custom-agents-for-cli) can tell the worker to read `MON-1`, propose the change and report what it ran, or return `BLOCKED` with the conflict, what it changed so far and the decision it needs. A coordinator can investigate how to meet both requirements. If the rule itself needs to change, that decision goes to its owner or someone explicitly authorized to make it. Until then, `MON-1` still applies and the monitor stays.

I'd tell the worker where to send that question before the task starts. On a routine change that might be the person reviewing the patch. If the worker finds a supported way to keep the monitor, it can carry on and leave the evidence with the change.

### 3. What was actually checked?

Start with what you need to see on the new path. Serving a request successfully is only half the check. The local verifier looks for a monitor event with the same request ID. Here's the idea for one request:

```js
const result = await serve({ id: requestId }, {
  log() {},
  monitor: (event) => events.push(event),
});

assert.equal(result.status, 200);
assert.ok(events.some((event) => event?.requestId === requestId),
  "MON-1: monitor must see this request");
```

From the [companion repository](https://github.com/dragoshont/when-done-isnt-done), run these with Node.js 24 or newer (I ran the tests on 26.13.0). The tests exercise passing and failing controls. The second command replays the bundled M2 input: both requests return `200`, but the verifier prints `HOLD` and exits `1` because the monitor saw neither request.

```text
node --test
node verify.mjs M2 inputs/M2/routes.json
```

For a real service, a PR job could run a verifier from the base revision against the candidate test merge commit. Have the job compare the checkout's SHA with the SHA GitHub assigned to the run before testing it.

I ran the verifier locally. I haven't run the illustrated GitHub setup. If you wire up a required check in your repository, verify that it blocks a candidate with a missing or failed result and that a pass on older code doesn't count. Protect the requirement, verifier, workflow and `.github/CODEOWNERS` with code-owner review. A check tied to a revision tells you what ran; it still matters who controls the check.

### Where each piece lives

Each layer does a different job, and only some of them can hold a change:

| Layer | In the sketch | What it can do |
| --- | --- | --- |
| Instruction | `requirements/monitor.md` (`MON-1`) | States the rule the handoff has to carry. |
| Agent profile (optional) | `.github/agents/worker.agent.md` | Shapes the worker in Copilot CLI: read `MON-1`, report what ran, or return `BLOCKED`. |
| Hook (optional) | None in the sample | Copilot CLI's `agentStop` or Claude Code's `Stop` could start the check at the end of a session. Only on that host. |
| Test | `verification/check-monitor.mjs` | Fails when the monitor doesn't see the request. |
| CI | `.github/workflows/verify-monitor.yml` | Illustrates running the base-revision verifier on the candidate. |
| Merge rule (optional) | Branch protection, set by hand | Can require `monitor-contract` and a maintainer review before merging. |

A profile or a hook helps the rule reach the right moment. The test produces evidence and the merge rule decides whether a passing check is required. The published verifier runs trusted handler code against route data. If a real CI check executes untrusted candidate code, keep it isolated and observe the behavior from outside that process.

### Proportionate, not paranoid

I wouldn't build a new verification workflow for a typo. I'd start with a requirement that would hurt if it disappeared and a regression check that fails when it does. For a live monitor, I'd exercise the deployed path and look for the matching event in the actual monitor, not just a callback in the same process.

OpenAI's report, updated on October 20, describes two changes. Auto-Review was updated to detect and block attempts to disable misalignment monitoring. Work toward safety cases for each type of workload, specifying the monitoring each one needs, was still in progress. The report doesn't give before-and-after results, and I haven't checked how well those changes work. My takeaway is that a rule in a prompt needs support: a review that can challenge the change, and a check that exercises the rule.

The useful question at the end of a review is the same one the completion report should help answer: what can I accept on this revision, and what is still open?

### Key Takeaways

On your next delegated patch, pick a rule that would be easy to lose and expensive to get wrong. Put it in the handoff with the change you want. If the worker finds a conflict, ask it to say accurately what it has done and send the open decision to someone who can make it. Then look for the check that exercises the rule on the exact revision in front of you. With that evidence, you can decide what to accept and what still needs work.

### Sources

- [OpenAI's October 6 incident report](https://openai.com/safety-alignment/misalignment-reports/suppressing-misalignment-monitoring-alerts-and-disabling-misalignment-monitoring/), including the October 20 update
- GitHub Docs: [CLI agent profiles](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-custom-agents-for-cli), [Copilot hooks](https://docs.github.com/en/copilot/reference/hooks-reference), [PR test merge commits](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#pull_request), [protected branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches) and [required status checks](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/collaborating-on-repositories-with-code-quality-features/troubleshooting-required-status-checks)
- Claude Code Docs: [hooks](https://code.claude.com/docs/en/hooks-guide)

---

*Disclaimer: All views expressed here are my own and do not represent the opinions of my current or former employers.*
