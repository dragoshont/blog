---
title: "Agentic AI in Software Delivery: Why Requirements Matter Most"
summary: "How autonomous AI agents can transform the requirements phase - the biggest bottleneck in software delivery."
date: 2025-11-09
description: "Exploring how agentic AI, RAG, and the Model Context Protocol can clarify requirements and accelerate software delivery."
author: "Dragos Hont"
tags: ["AI", "Software Engineering", "Requirements", "RAG", "MCP", "Agentic AI", "Governance"]
draft: false
categories: ["AI", "Software Delivery"]
keywords: ["agentic ai", "requirements", "spec driven", "mcp", "rag", "software delivery", "governance", "inner loop"]
ShowToc: false
TocOpen: false
cover:
  image: "/images/agentic-ai-cover.webp"
  alt: "Conceptual diagram of agentic AI improving software delivery requirements"
  caption: "Agentic AI accelerates clarity in the requirements phase"
  relative: false
---

One of the biggest shifts in computing over the past few years has been the rise of AI-powered agents. AI-powered agents, often built on foundational models like OpenAI's GPT-5 Codex, Google's Gemini, and Anthropic's Claude, are now integral to the enterprise, reshaping customer service, automating complex workflows, and even generating sophisticated content. These agents are also transforming specific professional domains. In the legal field, for instance, AI agents are revolutionizing e-discovery by sifting through millions of documents to identify relevant evidence, a task that once took teams of lawyers months to complete. Microsoft's Copilot for Microsoft 365 empowers employees by synthesizing vast amounts of internal data-from meeting recordings, communication channels, and documents-into an interactive knowledge source. In the development world, GitHub Copilot gives programmers the ability to build projects by drawing on the collective experience from hundreds of millions of projects in various languages, putting a vast repository of knowledge directly at their fingertips.

But when we zoom in on software delivery, the story gets even more interesting. Every project moves through familiar stages: requirements, design, implementation, testing, release and monitoring. AI can play a role in each of these, but the requirements phase is the real bottleneck. If the "what" and "why" are unclear, everything downstream - from design to testing - suffers. Requirements are often scattered across documents, tickets, chat threads and meeting notes, which forces developers to constantly switch context and slows down delivery.

This is where agentic AI comes in. Think of autonomous agents that specialise in tasks: one indexes enterprise sources, another summarises stakeholder input, another synthesises acceptance criteria, and yet another sequences tasks. Together, they can turn fragmented inputs into a living, machine-readable specification. Add IDE guardrails that surface the spec inline, and suddenly developers spend less time chasing context and more time building.

### Compliance and Security as First-Class Citizens

By exposing compliance rules, audit trails and security signals through MCP servers, organisations can ensure that generated requirements and tasks are automatically checked against policy and risk constraints. Security servers can surface threat models, dependency trackers and vulnerability feeds, while compliance servers provide evidence checklists and control mappings. This embeds governance and resilience directly into the workflow, reduces exposure to zero-day vulnerabilities and strengthens regulatory alignment.

### Governance Modes that Balance Speed and Control

Organisations can adopt different modes depending on risk: lightweight summarisation provides quick wins; assisted sequencing adds guardrails for teams seeking more structure; governed mode enforces mandatory quality gates for compliance-sensitive projects. MCP identity and audit layers help enforce role-based access and tamper-evident logs, which is critical for regulated industries.

### Spec-Driven Development and Good Requirements

Strong requirements are fundamental in spec-driven development. The specification acts as the contract for how code should behave. Clear, validated requirements reduce ambiguity, guide design decisions and improve automated testing. When agentic AI helps capture requirements early and link them to authoritative sources, it strengthens the delivery pipeline. Good requirements lead to fewer defects, faster reviews and smoother releases. Without them, even advanced AI orchestration cannot prevent misalignment and rework.

### Technical Patterns That Make It Practical

Two technical patterns make this practical. First, Retrieval-Augmented Generation (RAG) ensures agents pull relevant documents before generating outputs, reducing hallucinations and improving traceability. Second, the Model Context Protocol (MCP) standardises how agents access internal systems - whether that's documentation, ticket management, or repositories like Azure DevOps and GitHub. MCP servers are surprisingly simple to set up, and the marketplace of connectors is growing daily. Beyond requirements, MCP can also feed agents with incident monitoring data, project management tasks, compliance artefacts and component governance policies.

### Governance and Modes

Of course, governance matters. Organisations can adopt different modes depending on risk: lightweight summarisation for quick wins, assisted sequencing with guardrails for teams that want more structure, and governed mode with mandatory quality gates for compliance-sensitive projects. MCP's identity and audit layers help enforce role-based access and tamper-evident logs, which is critical for regulated industries.

### Ethics and Convergence

The ethical questions are still there: privacy, job displacement, bias. But with provenance, confidence scores and human sign-offs, agentic AI can be deployed responsibly. And it's not just about AI - software engineering provides the templates and CI/CD pipelines, while cybersecurity ensures access control and compliance alignment. It's a convergence of disciplines, and requirements are the keystone.

### A Glimpse into an Automated Specification Toolkit

To make this tangible, imagine a development workflow orchestrated as a seamless collaboration between the developer and their AI partner. This isn't about replacing the developer, but augmenting their expertise. The process unfolds in a cyclical, quality-driven loop:
![Spec-driven development workflow diagram](/images/spec-driven.png)

First, **a foundation of principles is established.** Before any work begins, the project is grounded in a "constitution," which is a set of governing principles, architectural guidelines, and development best practices. When a new feature request arrives, an AI agent immediately assesses it against this constitution, ensuring every new endeavor aligns with the organization's strategic goals and technical standards from the very first step.

With that baseline established, the focus shifts to **defining the core requirements.** This becomes a structured dialogue where the developer and the agent co-create the initial specification. The agent helps translate high-level ideas into clear, well-defined user stories and requirements, forming the blueprint for the feature.

From there, the process enters a crucial **cycle of refinement and validation.** This is where the real power of collaboration shines. The developer can prompt the agent to dive deeper, clarifying ambiguities and surfacing underspecified areas that could cause problems later. To take quality a step further, the agent can generate custom checklists to systematically validate the requirements for completeness and consistency, acting as a form of "unit testing" for the specification itself.

Once the requirements are robust, the developer and agent move on to **planning the technical implementation.** The agent, with its broad knowledge of the existing codebase and the project's tech stack, proposes a detailed technical plan. This plan is then meticulously broken down into a granular list of actionable tasks, providing a clear roadmap for the development team.

Before a single line of code is written, a **final automated analysis ensures cohesion.** The agent performs a comprehensive check across all artifacts, including the requirements, the technical plan, and the generated tasks. It flags any inconsistencies or gaps, ensuring that what was specified is what was planned, and what was planned is what will be built.

Only after this rigorous, multi-layered validation does the developer proceed with **confident implementation.** With a thoroughly vetted and deeply understood plan in hand, they can focus on the creative work of building, secure in the knowledge that the groundwork is solid, the vision is clear, and the risk of costly rework has been dramatically minimized.

### Key Takeaways

- **Requirements are the bottleneck:** Unclear "what" and "why" slow delivery more than any other stage.
- **Agentic AI clarifies intent:** Specialized agents synthesize fragmented inputs into living specifications.
- **The developer becomes the validator:** The workflow shifts the developer's role from low-level information gathering to high-level validation of the AI's output.
- **Collaboration is cyclical, not linear:** The process emphasizes a continuous loop of refinement and validation, making the plan more robust before implementation.
- **RAG retrieval reduces risk:** Pulling relevant documents before generation improves accuracy and provenance.
- **MCP connectors simplify integration:** Internal docs, tickets, and repos can be exposed securely, with a growing marketplace of ready-made servers.
- **Compliance and security are embedded:** MCP servers enforce policies, track dependencies, and surface vulnerabilities to strengthen resilience.
- **Governance is essential:** Lightweight, assisted, and governed modes balance speed with compliance.
- **Spec-driven development depends on good requirements:** Strong, validated specs are the foundation for reliable delivery.

Disclaimer: All views expressed here are my own and do not represent the opinions of my current or former employers.



