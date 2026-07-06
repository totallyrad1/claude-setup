# claude-setup

My personal Claude Code config — CLAUDE.md rules, custom slash commands, and settings.

## What's here

| File | Purpose |
|---|---|
| `CLAUDE.md` | Global instructions loaded in every session |
| `RTK.md` | RTK token-killer docs (referenced by CLAUDE.md) |
| `settings.json` | Claude Code settings (theme, model, effort). Safe, portable defaults — no hooks enabled by default |
| `commands/` | Custom slash commands (`/frontend-design`, `/thermonuclear-review`) |

## Setup on a new machine

```bash
# Clone the repo
git clone https://github.com/totallyrad1/claude-setup.git

# Copy config files
cp claude-setup/CLAUDE.md ~/.claude/CLAUDE.md
cp claude-setup/RTK.md ~/.claude/RTK.md
cp claude-setup/settings.json ~/.claude/settings.json
mkdir -p ~/.claude/commands
cp claude-setup/commands/*.md ~/.claude/commands/
```

> `settings.json` ships with safe, portable defaults only (`theme`, `model`, `effortLevel`) — tweak these to taste; they're just my personal preferences.

## Optional extras (not enabled by default)

These are part of my personal setup but intentionally left out of `settings.json` so this works cleanly on a fresh machine. Add them only if you want them:

- **RTK token-killer hook** — rewrites shell commands through `rtk` to save tokens. Only add this after installing RTK, or every Bash command will fail with `command not found`:

  ```json
  "hooks": {
    "PreToolUse": [
      { "matcher": "Bash", "hooks": [ { "type": "command", "command": "rtk hook claude" } ] }
    ]
  }
  ```

- **Status line** — I run a custom `~/.claude/statusline-command.sh` (not included here). Add your own and point to it:

  ```json
  "statusLine": { "type": "command", "command": "bash ~/.claude/statusline-command.sh" }
  ```
