@RTK.md

# Git: No Remote Updates Without Explicit Consent

## Hard requirement

- **Do not** run `git push`, `git push --force`, `git push --force-with-lease`, or any command that updates a remote (including `gh pr create` / `gh` flows that push) unless the user **clearly and explicitly** asked to push in that message (e.g. "push to `origin`", "run `git push`", "push this branch", "open a PR and push").
- **"Commit"**, **"stage"**, **"prepare a PR"**, or **"get it merge-ready"** does **not** imply permission to push. Only prepare commits locally, show `git status` / diff, and give the exact commands if they want to push themselves.
- If the user asked for a commit but not a push: commit locally is allowed; still **no push** unless they also explicitly asked to push.

## If a push would help

- Say what you would push (branch, remote) and **ask once** with a single yes/no. Do not push until they confirm.
