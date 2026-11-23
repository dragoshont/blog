---
title: "What Comes With You? Reusing Agent Harness Components"
slug: what-comes-with-you-agent-harness-components
description: "You're adding a feature in a different setup. Follow one model turn and one compatibility check to see what you can bring along, what you have to reconnect and how to test a component swap."
author: Dragos Hont
date: 2026-11-24
draft: false
---

### Starting in a different setup

Say I'm about to add a feature. Maybe I'm on a new laptop, working in a different VM, or picking up a project I've never worked on before. I open the repo and ask a coding assistant to help. The ticket tells me what to build. It may say less about what already has to keep working and which check will tell me if I've broken it.

The check might already live in the repo. Maybe the previous assistant knew when to run it, or someone on the team always ran it by hand. If I'm using a different assistant now, what can I carry over, and what do I need to set up again?

That's the question behind a talk I'm preparing. Take an orders API that needs a clearer field for the delivery time, `estimatedDeliveryAt`. The old mobile app still reads `ETA`, so both fields need to carry the same time. Before I get to that check, it helps to look at what happened around the code in the old setup.

### One turn, and everything around it

Start with a single model turn. The harness assembles the input and calls the model. The model may ask for a tool. The harness decides whether that call can run, runs it if allowed and chooses which result goes into the next turn. Then the loop goes around again.

Now follow one code change through that loop. Who decided which files to read? Who chose to run the tests? Could the run have finished without them? The answer can come from the model, from a project instruction, from the runtime's permissions, or from me approving a command. The diff shows none of that. A trace can show which decisions came from where.

That's the part I'm really asking about when I switch setups. The context the harness assembled, the permissions it applied, and the rule that let the run stop all helped shape the result. If it brings a child session into the work, there's another question: which parts of the task does the child get, and what evidence makes it back?

### Sometimes a handover is enough

If I'm partway through that API change when I switch, I'd leave a short note with the decision and the unfinished work: keep `ETA` until the old app is retired; say what changed in the serializer and what still needs to be checked. That gives the next session a place to start.

A month later, another ticket changes the response. A note from the last session won't help much there. I'd want the legacy-client regression test in the repository with a short recipe: when to run it, which command to use and what result to report. A handoff carries one piece of work to the next session. Reusable behavior has to live somewhere the next assistant can find it and run it without reconstructing the old conversation.

### What stays with the old setup

When I move between GitHub Copilot and Codex, it's the corrections from the middle of a long session that I worry about losing. If I open the same branch in OpenCode, I can see what changed. I can't tell from the diff why we decided to keep `ETA` or which approach we already ruled out. I'd put the decisions the next assistant needs somewhere it can find them.

At work, the decision might be in a Teams conversation my setup can find through Work IQ. If I move to an open-source assistant, I have to check whether it can connect to the same source, whether my organization allows that connection, and what the signed-in account can read. A link to the discussion can travel with the handoff. Access to the discussion doesn't travel with it.

### Swapping a piece, or moving the whole thing

There are two different moves here, and I find it useful to keep them apart.

**Within a host**, start with the behavior you want to change. Maybe the assistant should look up a project decision before the first model call. A skill can explain when to search. If the note has to be in the first request, look for a way to change how the host assembles that request. A setting or a supported extension may be enough.

**Across hosts**, that same lookup might be available as a tool the model can call. It can still find the right note, but the result now arrives after the model asks for it. To get the old behavior back, I'd look for the point where the new host assembles its first request and check what actually goes into it.

I ask three things before I go deeper: what am I trying to change, who can make it happen on the path I care about, and can I replace that part on its own? A supported extension can save me from owning a fork. If I do replace a component, I also own the adapter and the tests that tell me whether the next host update broke it.

For the orders API, I'd start with the smaller move. Keep the runner and the compatibility check in place, swap only the adapter that reads the model's reply, and see whether the old app still gets `ETA`.

### Four parts of a turn

By *harness*, I mean the code around the model that prepares its input, runs approved actions and checks what came out. In this example there are four pieces:

1. **Prepare the request.** `runner.mjs` passes the ticket and the `ETA` constraint to `propose(ticket)`. In the demo that function returns a proposal from a local fixture.
2. **Read the reply.** `runner.test.mjs` loads local fixtures and exercises `adapter-chat.mjs` and `adapter-messages.mjs`. Each extracts one proposed action from a different response format.
3. **Run an allowed action.** The runner permits one action, `set_delivery_fields`. `orders.mjs` serializes those fields into an in-memory response. There is no shell command or file edit.
4. **Check the response.** `check-eta.mjs` reads the response as a client would. The runner returns `ready for review` only after that check passes.

![The two reply adapters hand the runner the same action shape. The runner applies the allowed action and checks the serialized response before it marks the candidate ready for review.](/images/what-comes-with-you-figure.svg)

*Swap either reply adapter at the top. The files that apply the change and check `ETA` stay in place. The sketch shows a demo entry point and optional host wiring; `runner.test.mjs` drives the fixtures in the published repo.*

### A small example: the ETA field

To try the swap, start with the same ticket and the same proposed fields. The local fixtures wrap that proposal in two different reply formats. Both adapters hand the runner the same narrow action, and the runner still decides what it can do with it:

```js
const action = await propose("Add estimatedDeliveryAt. Keep ETA for older clients.");
```

In [`runner.mjs`](https://github.com/dragoshont/agent-harness-reuse/blob/main/runner.mjs), an allowed action can still be wrong. `set_delivery_fields` with just `estimatedDeliveryAt` is well-formed and can run. [`check-eta.mjs`](https://github.com/dragoshont/agent-harness-reuse/blob/main/check-eta.mjs) then checks both names and their value. The old client has made the decision for us: a response without `ETA` doesn't work.

From the [companion repository](https://github.com/dragoshont/agent-harness-reuse), with Node.js 24 or newer (I ran this on 26.13.0), run:

```text
node --test runner.test.mjs
```

The four tests check that both adapters preserve the delivery time, that a well-formed proposal dropping `ETA` is held, that the wrong time fails the check, and that an unsupported action is refused. The command passes when all four behaviors are observed, including the deliberate rejection.

### Where each piece lives

When I move this to a new setup, I check each layer separately, because they don't carry the same weight:

| Layer | In this sample | What it can do |
| --- | --- | --- |
| Instruction | The ticket text in `runner.mjs`: keep `ETA` for older clients | Tells the model what to keep. The model can still get it wrong. |
| Agent profile | None in the published sample. | Shapes how a worker agent behaves in one host. |
| Skill (optional) | A project `SKILL.md`, if you add one. | Tells the assistant when to run the test and what to report. It doesn't run anything by itself. |
| Hook (optional) | None in the sample | Can start the test when a session stops. It fires only on that host's event. |
| Test | `check-eta.mjs`, `runner.test.mjs` | The actual evidence: fails when `ETA` is missing or wrong. |
| Runner or CI | `runner.mjs` | Refuses unsupported actions and holds a response that fails the check. A CI job for this sample isn't included. |

The instruction and skill say what to do. A hook can start a check when its event fires. Here, `runner.mjs` calls the check directly and returns `ready for review` only after it passes.

### What the receiver still owns

In the new setup, first see if the compatibility check runs directly from the repository. Then see if the new assistant can find the recipe. You could put a `SKILL.md` under `.claude/skills/check-order-eta/`, a project skill location documented by both [Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-skills) and [Claude Code](https://code.claude.com/docs/en/skills). You can reuse the skill where the new host discovers it and can run the command under its own permissions. If the host looks elsewhere, put the recipe in its supported location. For a real orders service, point it at the repo's legacy-client regression test.

If the old setup ran the command automatically, reconnect that trigger and check that it fires on the new host. Copilot CLI calls its stop event [`agentStop`](https://docs.github.com/en/copilot/reference/hooks-reference); Claude Code calls it [`Stop`](https://code.claude.com/docs/en/hooks-guide). Each has its own configuration, so adapt the hook where it calls the shared check. Have the receiving host enforce its own action permissions. I'd put the acceptance rule in the runner or CI so the maintainer can ask for a passing check on the revision under review. The sample's `ready for review` status is where that review starts.

### What I've run, and what I haven't

There are three different kinds of evidence behind this article, and they don't prove the same thing.

- **Fixture adapters.** The tests above use local JSON. `propose()` returns the fixture; no model is called. The tests show the runner and the check behave the same with two reply formats. They don't show that any model produces those replies.
- **Observed live CLI cases.** Separately, Copilot CLI `1.0.115-8` and OpenCode `2.4.1` got the same prompt bytes for four synthetic cases. Each case had one fresh attempt per host, with GPT-6.2 Sol selected on both. OpenCode's event output doesn't identify the model independently. The independent verifiers returned the same four results on both hosts: the monitored route migration was `READY`, the log-only route was `HOLD`, the compatible field proposal was `READY`, and the replacement-only proposal was `HOLD`. No tool execution was observed. Those cases ran against separate verifiers from the fixture demo above.
- **The standalone library swap is still a proposal.** I'd keep the runner and replace only the library that sends the request to the model. I've looked at possible clients in Pi and OpenCode, but I haven't run that comparison.

For a live client swap, start from the same revision, keep the model, request, tool permissions and acceptance rule fixed where you can, and check how each client reports a proposed action, errors and streaming output. Different edits can satisfy the same contract.

### Key Takeaways

If you switch assistants in the middle of a change, a short handoff gives the next session a place to start. A regression test and its recipe give future changes the same protection. Before you move anything, follow one turn and find out what decided which files were read, which commands ran and when the run could stop. If you're replacing one component within a host, change only that piece and check that both versions preserve the old client's delivery time, then run the broken proposal and see whether the runner keeps it open. Moving across hosts is a bigger step: check that the new host finds the recipe, that any hook you rely on fires, and that the maintainer still has a check to review before approving the change.

### Sources

- Response formats used to write the local fixtures: [OpenAI Chat Completions](https://developers.openai.com/api/reference/resources/chat) and [Anthropic Messages](https://platform.claude.com/docs/en/api/messages)
- Host documentation: [Copilot CLI skills](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-skills), [Claude Code skills](https://code.claude.com/docs/en/skills), [Copilot hooks](https://docs.github.com/en/copilot/reference/hooks-reference) and [Claude Code hooks](https://code.claude.com/docs/en/hooks-guide)

---

*Disclaimer: All views expressed here are my own and do not represent the opinions of my current or former employers.*
