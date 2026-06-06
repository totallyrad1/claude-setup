# claude-setup

My personal Claude Code config — CLAUDE.md rules, custom slash commands, and settings.

## What's here

| File | Purpose |
|---|---|
| `CLAUDE.md` | Global instructions loaded in every session |
| `RTK.md` | RTK token-killer docs (referenced by CLAUDE.md) |
| `settings.json` | Claude Code settings (hooks, theme, model, etc.) |
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

> Note: `settings.json` has a hook that calls `rtk` — install RTK first or remove that hook.
