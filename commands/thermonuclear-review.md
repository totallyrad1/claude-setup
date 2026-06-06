# Thermo-Nuclear Code Quality Review

Use this prompt for an unusually strict review focused on implementation
quality, maintainability, abstraction quality, and codebase health.

Above all, this prompt should push you to be ambitious about code structure.
Do not merely identify local cleanup opportunities. Actively search for
**"code judo" moves**: restructurings that preserve behavior while making
the implementation dramatically simpler, smaller, more direct, and more
elegant.

## Core Prompt

Perform a deep code quality audit of the current branch's changes. Rethink
how to structure / implement the changes to meaningfully improve code quality
without impacting behavior. Work to improve abstractions, modularity, reduce
spaghetti code, improve succinctness and legibility. Be ambitious — if there
is a clear path to improving the implementation that involves restructuring
some of the codebase, go for it. Be extremely thorough and rigorous. Measure
twice, cut once.

## Non-Negotiable Additional Standards

0. **Be ambitious about structural simplification.**
   - Do not stop at "this could be a bit cleaner."
   - Look for opportunities to reframe the change so that whole branches,
     helpers, modes, conditionals, or layers disappear entirely.
   - Prefer the solution that makes the code feel inevitable in hindsight.
   - Assume there is often a "code judo" move available: a re-organization
     that uses the existing architecture more effectively and makes the change
     dramatically simpler and more elegant.
   - If you see a path to delete complexity rather than rearrange it, push
     hard for that path.

1. **Do not let a PR push a file from under 1k lines to over 1k lines without
   a very strong reason.**
   - Treat this as a strong code-quality smell by default.
   - Prefer extracting helpers, subcomponents, modules, or local abstractions.
   - Explicitly ask whether the code should be decomposed first.

2. **Do not allow random spaghetti growth in existing code.**
   - Be highly suspicious of new ad-hoc conditionals, scattered special
     cases, or one-off branches inserted into unrelated flows.
   - If a change adds "weird if statements in random places", treat that as
     a design problem, not a stylistic nit.
   - Call out changes that make the surrounding code harder to reason about,
     even if they technically work.

3. **Bias toward cleaning the design, not just accepting working code.**
   - Do not rubber-stamp "it works" implementations that leave the codebase
     messier.
   - Strongly prefer simplifications that remove moving pieces altogether.

4. **Prefer direct, boring, maintainable code over hacky or magical code.**
   - Treat brittle, ad-hoc, or "magic" behavior as a code-quality problem.
   - Flag thin abstractions, identity wrappers, or pass-through helpers that
     add indirection without buying clarity.

5. **Push hard on type and boundary cleanliness when they affect
   maintainability.**
   - Question unnecessary optionality, `unknown`, `any`, or cast-heavy code.
   - Prefer explicit typed models over loosely-shaped ad-hoc objects.

6. **Keep logic in the canonical layer and reuse existing helpers.**
   - Call out feature logic leaking into shared paths.
   - Push code toward the right package, service, or module.

7. **Treat unnecessary sequential orchestration and non-atomic updates as
   design smells.**
   - If independent work is serialized for no good reason, ask whether the
     flow should run in parallel instead.
   - If related updates can leave state half-applied, push for a more atomic
     structure.

## Primary Review Questions

For every meaningful change, ask:

- Is there a "code judo" move that would make this dramatically simpler?
- Can this change be reframed so fewer concepts, branches, or helper layers
  are needed?
- Does this improve or worsen the local architecture?
- Did the diff add branching complexity where a better abstraction should
  exist?
- Did a previously cohesive module become more coupled or harder to scan?
- Is this logic living in the right file and layer?
- Did this change enlarge a file or component past a healthy size boundary?
- Are there repeated conditionals that signal a missing model or helper?
- Is this abstraction actually earning its keep, or is it just a wrapper?
- Did the diff introduce casts, optionality, or ad-hoc object shapes that
  obscure the real invariant?

## What to Flag Aggressively

- A complicated implementation where a cleaner reframing could delete whole
  categories of complexity.
- A file crossing 1000 lines due to the PR.
- New conditionals bolted onto unrelated code paths.
- One-off booleans, nullable modes, or flags that complicate existing flow.
- Feature-specific logic leaking into general-purpose modules.
- Generic "magic" handling that hides simple structure.
- Thin wrappers or identity abstractions.
- Unnecessary casts, `any`, `unknown`, or optional params.
- Copy-pasted logic instead of extracted helpers.
- Narrow edge-case handling inside an already busy function.
- Bespoke helpers where a canonical utility exists.
- Sequential async flow where parallel execution would be cleaner.
- Partial-update logic that leaves state less atomic than necessary.

## Preferred Remedies

- Delete a whole layer of indirection rather than polishing it.
- Reframe the state model so conditionals disappear.
- Change the ownership boundary so the feature becomes a natural extension.
- Turn special-case logic into a simpler default flow with fewer exceptions.
- Extract a helper or pure function.
- Split a large file into smaller focused modules.
- Replace condition chains with a typed model or explicit dispatcher.
- Separate orchestration from business logic.
- Collapse duplicate branches into a single clearer flow.
- Reuse the existing canonical helper instead of introducing a near-duplicate.
- Make type boundaries more explicit so the control flow gets simpler.
- Move the logic to the package/module/layer that already owns the concept.

Do not be satisfied with "maybe rename this" feedback when the real issue is
structural. Do not be satisfied with a merely cleaner version of the same
messy idea if there is a plausible path to a much simpler idea.

## Review Tone

Be direct, serious, and demanding about quality. Do not be rude, but do not
soften major maintainability issues into mild suggestions.

Good phrases:

- `this pushes the file past 1k lines. can we decompose this first?`
- `this adds another special-case branch into an already busy flow. can we move this behind its own abstraction?`
- `this works, but it makes the surrounding code more spaghetti. let's keep the behavior and restructure the implementation.`
- `this feels like feature logic leaking into a shared path. can we isolate it?`
- `this abstraction seems unnecessary. can we just keep the direct flow?`
- `why does this need a cast / optional here? can we make the boundary more explicit instead?`
- `i think there's a code-judo move here that makes this much simpler. can we reframe this so these branches disappear?`
- `this refactor moves complexity around, but doesn't really delete it. is there a way to make the model itself simpler?`

## Output Expectations

Prioritize findings in this order:

1. Structural code-quality regressions
2. Missed opportunities for dramatic simplification / code-judo restructuring
3. Spaghetti / branching complexity increases
4. Boundary / abstraction / type-contract problems
5. File-size and decomposition concerns
6. Modularity and abstraction issues
7. Legibility and maintainability concerns

Do not flood the review with low-value nits if there are larger structural
issues. Prefer a small number of high-conviction comments over a long list
of cosmetic notes.

## Approval Bar

The bar for approval is:

- No clear structural regression
- No obvious missed opportunity to make the implementation dramatically simpler
- No unjustified file-size explosion
- No obvious spaghetti-growth from special-case branching
- No obviously hacky or magical abstraction
- No unnecessary wrapper/cast/optionality churn
- No clear architecture-boundary leak or canonical-helper duplication
- No missed opportunity for an obvious decomposition

Treat these as presumptive blockers unless the author can justify them clearly:

- The PR preserves incidental complexity when a code-judo move could delete it
- The PR pushes a file from below 1000 lines to above 1000 lines
- The PR adds ad-hoc branching that makes an existing flow more tangled
- The PR scatters feature checks across shared code
- The PR adds an unnecessary abstraction or cast-heavy contract
- The PR duplicates an existing helper or puts logic in the wrong layer
