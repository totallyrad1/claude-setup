---
description: Review one or more PRs through N sequential adversarial batches — each batch is a fresh zero-context subagent reviewing the CURRENT state including your own fixes from the previous batch. Triage, fix, verify between batches. Ends with a merge/ship verdict. Does not push or merge unless asked.
argument-hint: "[batches] [PR url | #number | 'current branch'] ..."
---

# /batch-review — N adversarial review batches over a PR (or a paired set)

`$1` is the number of batches. Everything after it is the PR (or PRs) to review.
If `$1` is not a number, default to **3** and treat all arguments as PRs.

Arguments given: `$ARGUMENTS`

Two or more PRs given together are treated as **one paired change** (e.g. a backend PR
and the frontend PR that calls it). Review them as a unit — the contract between them is
usually where the real defects are.

## What this authorizes

- Reading, checking out worktrees, running tests/builds/linters
- **Fixing** the real findings, in the worktrees, and committing locally
- **NOT** pushing, **NOT** merging, **NOT** commenting on the PR — unless the user's
  invocation explicitly asks (e.g. "…and merge if it's clean", "push the fixes")

If the PR belongs to someone else, say so before committing to their branch, and never
push to it without the user saying so in that message.

---

## Phase 1 — set up and establish a baseline

1. `gh pr view <n> --json number,title,body,baseRefName,headRefName,author,state,mergeable,mergeStateStatus,additions,deletions,changedFiles`
   for each PR. Note the **base branch** — a PR into `main` may be shipping straight to
   production; say so out loud.
2. `gh pr view <n> --json statusCheckRollup` — get the real check names, not just
   pass/fail. A green tick from a bot that only posts summaries is not CI.
3. Create a git worktree per repo at the PR head. Symlink `node_modules` from the main
   checkout so you can run things. Generate any client the repo needs (`prisma generate`).
4. **Capture the baseline before touching anything**: full test count, typecheck result,
   lint count. You need these to prove you did not regress something, and to tell a
   pre-existing failure from one you caused.
5. **Identify sandbox artifacts now.** Symlinked `node_modules`, pnpm layouts and
   generated clients routinely produce errors that do not exist in CI. Verify by running
   the same command against the *pristine* PR head. Anything that reproduces there is an
   artifact — write it into every batch brief as "ignore, do not report".

## Phase 2 — the batch loop, ONE AT A TIME

Batches are sequential, never parallel. Batch N+1 must review the code **as fixed by
batch N**, including your fixes, or the loop is worthless.

For each batch:

**a. Write a brief to a scratch file** and pass its path to the subagent. Every brief has:

- What the change is, and where the worktrees are
- The **base branch** and whether merging ships to production
- Baseline numbers and the sandbox artifacts to ignore
- **ALREADY FOUND — do not re-report**: every finding from previous batches, marked
  fixed / left-with-reason. This is what stops batch 3 rediscovering batch 1.
- **This batch's focus.** Do not send the same brief N times. Split the surface:
  security/core logic → integration and contracts → UI/UX and error paths →
  config/ops/docs/tests → adversarial re-verification of everything, especially your fixes.
- The rules block (below), verbatim.

**b. Rules block for every subagent:**

> - **Review only. Do NOT modify, stage, commit, push, or merge anything.** Delete any
>   scratch file you create and leave the worktree byte-identical to how you found it.
> - **Verify by running, not by reading.** Write a throwaway test to prove a claim.
>   Mutate the source and confirm a test dies — a test that survives its mutation is
>   decorative and that is itself a finding.
> - **Do not trust commit messages or code comments.** Check the file on disk.
> - Precision over volume. A false positive costs more than a miss. Every finding needs
>   `file:line`, a concrete triggering input, and the wrong outcome.
> - Zero findings is a valid result.
> - End with a short "checked and clean" list.

**c. When the batch reports, triage every finding yourself.** Do not fix on trust —
subagents are confidently wrong sometimes. For each: reproduce it, then classify as
real-and-fix, real-but-deliberate (say why), or wrong (say why).

**d. Fix the real ones. Then attack your own fixes:**

- **Verify the edit actually landed.** Re-read the file, or `grep` for the old string and
  confirm it is gone. A script that batches edits in memory and writes once at the end
  will silently drop everything if it exits early — this has happened, and produced a
  commit message describing changes that did not exist.
- **Mutation-test each fix**: revert it, confirm a named test fails, restore. If the
  mutation survives, your fix has no protection and will be silently undone later.
- **Never run a formatter** without first confirming the repo has a config for it. A repo
  with no `.prettierrc` will be reformatted wholesale and bury a 100-line change in 2000
  lines of noise.
- Re-run the full suite and typecheck. Compare to the baseline.
- Commit locally with a message that says what was wrong and why the fix is right.

**e. Feed the fixes into the next brief** as review targets. Tell the next batch
explicitly: *"these are my fixes, they are unreviewed, try to break them."* In practice a
large share of later findings are defects in earlier fixes.

## Phase 3 — final report

- **Verdict**, and split it: **safe to MERGE** is not the same as **safe to SHIP/ENABLE**.
  A feature behind an off-by-default flag can be perfectly safe to merge and nowhere near
  ready to turn on. Say which is which.
- Findings by batch: what was found, what you fixed, what you deliberately left and why.
- Anything that needs a human decision — product calls, clinical/financial judgement,
  things the author intended that you disagree with.
- Final state: test counts vs baseline, typecheck, lint, CI, `mergeable`/`mergeStateStatus`.
- Follow-ups worth their own ticket.
- **Be honest about your own errors.** If a batch caught a defect in your fix, say so
  plainly in the report. That is the loop working, not a failure to hide.

## Things that have actually gone wrong — check for each

- A fix applied to one file but claimed for six (verify on disk)
- Tests updated to match a fix instead of the fix being questioned (ask: did I just bend
  the test?) — if you change an asserted behaviour, flag it to the user explicitly
- A rate limit keyed on IP when the requirement was per-user
- A guard that predicts which branch will run instead of gating the branch that does run
- Comments and docs left describing the pre-fix behaviour, so the file contradicts itself
- Duplicate copies of the same constants in another repo that now silently disagree
- "Green CI" that runs only on some branches, or only posts a summary
