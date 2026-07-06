# claude-setup

My personal Claude Code config — CLAUDE.md rules, custom slash commands, and settings.

## What's here

| File | Purpose |
|---|---|
| `CLAUDE.md` | Global instructions loaded in every session |
| `RTK.md` | RTK token-killer docs (referenced by CLAUDE.md) |
| `settings.json` | Claude Code settings (theme, model, effort). Safe, portable defaults — no hooks enabled by default |
| `commands/` | Custom slash commands (`/frontend-design`, `/thermonuclear-review`, `/peel-the-question`) |
| `statusline-command.sh` | Optional status line script (cwd, git branch, RTK savings) |
| `notify.sh` | Optional "Claude finished" desktop notification hook (WSL/Windows only) |
| `examples/` | Sample project-level `CLAUDE.md` files |

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

- **Status line** — `statusline-command.sh` (included) shows the current dir, git branch, and RTK savings. Copy it and point `settings.json` at it:

  ```bash
  cp claude-setup/statusline-command.sh ~/.claude/statusline-command.sh
  ```

  ```json
  "statusLine": { "type": "command", "command": "bash ~/.claude/statusline-command.sh" }
  ```

  (The RTK-savings segment is skipped automatically if `rtk` isn't installed; the rest still works.)

- **Finish notification** — `notify.sh` (included) pops a "Claude Code finished" toast. It's **WSL/Windows-only** (it calls `powershell.exe`); on macOS/Linux, swap the body for `osascript`/`notify-send`. Enable via a `Stop` hook:

  ```bash
  cp claude-setup/notify.sh ~/.claude/notify.sh
  ```

  ```json
  "hooks": {
    "Stop": [
      { "matcher": "", "hooks": [ { "type": "command", "command": "bash ~/.claude/notify.sh" } ] }
    ]
  }
  ```

## External tools I use (install separately)

Not included here because they're third-party, but my config references them:

- **RTK** (Rust Token Killer) — the `rtk` hook above and `RTK.md`.
- **graphify** — a knowledge-graph `/graphify` skill (`pip install graphifyy`, see [safishamsi/graphify](https://github.com/safishamsi/graphify)). The `examples/` CLAUDE.md shows how I wire it into a project.
