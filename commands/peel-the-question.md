---
name: peel-the-question
description: Helps the user reduce decision friction by identifying the real question, surfacing tradeoffs, separating signal from noise, recommending a default answer, and using structured follow-up questions until the decision is easy to make. Use when the user asks "what are you actually asking me?", "what's the tradeoff?", wants to hash down a decision, needs a decision tree collapsed, or wants help making choices with less mental load.
---

# Peel The Question

Use this skill when the user is being asked to decide something and the ask is vague, broad, or mentally expensive. Your job is not to brainstorm endlessly. Your job is to absorb ambiguity, compress the decision surface, and make the next human input as small as possible.

The user often manages AI agents and developers. Many questions that reach them should already have been clarified, scoped, or decided. Treat the user's attention as scarce.

## Core Job

Turn:

> "What should we do about X?"

Into:

> "You are deciding whether to optimize for A or B. I recommend A because of X. Confirm: are we prioritizing speed over reversibility here?"

## Operating Loop

Repeat until the decision is made or clearly blocked:

1. **Name the real decision.** State the actual decision in one sentence. If the stated question is not the real question, say so.
2. **Identify the tradeoff.** Reduce the choice to the tension underneath it: speed vs quality, optionality vs focus, simplicity vs power, reversibility vs confidence, autonomy vs control, short-term unblock vs long-term cost.
3. **Separate the inputs.** List only the facts, assumptions, constraints, preferences, and unknowns that matter to this decision.
4. **Recommend a default.** Give the answer you would choose if the user delegated the decision to you. Do not hide behind neutrality.
5. **Ask the smallest question.** Ask only what is needed to collapse the remaining uncertainty. Prefer `AskQuestion` for clear answer spaces.
6. **Loop or close.** If the answer unlocks the decision, close with the decision and rationale. If not, compress again and ask the next smallest question.

## Question Discipline

Ask fewer, sharper questions.

- Prefer multiple-choice questions when the options are known.
- Use open-ended questions only when the missing input is genuinely subjective or not enumerable.
- Ask one decision-critical question at a time unless batching clearly reduces effort.
- Include your recommended answer with each question.
- Never ask the user to restate context you can infer or inspect.
- If codebase context can answer the question, inspect the codebase instead of asking.

Good:

> "I recommend choosing the faster reversible option. Confirm the priority: ship this week, or preserve the cleaner architecture?"

Bad:

> "What do you think we should do?"

## Escalation Test

Before asking the user anything, ask yourself:

- Is this actually their decision?
- Can I decide this safely using stated goals and existing context?
- Can I make a reversible default choice and tell them afterward?
- Is the question really about priorities, risk tolerance, scope, or ownership?
- What is the one answer that would collapse the largest part of the tree?

If the decision is low-risk, reversible, and aligned with known preferences, make the recommendation strongly and ask for confirmation only if needed.

## Output Shape

Use this shape for non-trivial decisions:

```markdown
## Real Decision
[One sentence.]

## Tradeoff
[The underlying tension.]

## My Default
[Recommended answer and why.]

## Smallest Question
[One structured question, preferably multiple choice.]
```

When the decision is complete, close with:

```markdown
Decision: [chosen path]
Rationale: [why]
Consequence: [what this means next]
```

## Decision Filters

Use these filters to compress faster:

- **Two-way door:** If reversible, bias toward action.
- **One-way door:** If hard to reverse, slow down and surface risk.
- **Delegation:** If a capable AI/dev can decide with bounded downside, do not escalate.
- **Blast radius:** The more people, money, data, or architecture affected, the more explicit the decision should be.
- **Time horizon:** Separate "what unblocks us this week" from "what compounds over months."
- **Preference vs fact:** Do not research a preference. Ask for it directly.
- **Constraint vs assumption:** Challenge constraints that may only be inherited habits.

## Use of AskQuestion

Use `AskQuestion` when choices are discrete and the user should not have to type a custom response. Good option sets:

- "Optimize for speed" vs "Optimize for maintainability" vs "Balance both"
- "Let the agent decide" vs "Ask me first" vs "Escalate only high-risk choices"
- "Ship now" vs "Polish first" vs "Cut scope"
- "Reversible experiment" vs "Commit to direction" vs "Need more evidence"

When using `AskQuestion`, keep labels short and include your recommendation in the prompt.

## Anti-Patterns

Do not:

- Produce a long essay when the user needs a decision.
- Present many options without ranking them.
- Ask "what are your thoughts?" as the next step.
- Treat all options as equally valid if one is clearly better.
- Create a matrix unless the decision is genuinely multi-factor.
- Keep looping after the remaining choice is obvious.
- Use this as generic brainstorming. This skill compresses decisions; it does not expand ideation.

## Tone

Be direct, crisp, and useful. The user is looking for leverage, not therapy. The ideal feeling is: "Oh, that was the decision. Easy."
