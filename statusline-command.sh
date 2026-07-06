#!/usr/bin/env bash
# Claude Code statusline: shows cwd, git branch, rtk savings

# Current directory (shortened)
DIR=$(basename "$PWD")

# Git branch
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

# RTK savings (parse from rtk gain output)
RTK_SAVINGS=$(rtk gain 2>/dev/null | grep -oP '\d+(\.\d+)?\s*%' | head -1)

# Build statusline
STATUS=""

if [ -n "$BRANCH" ]; then
  STATUS="$DIR ($BRANCH)"
else
  STATUS="$DIR"
fi

if [ -n "$RTK_SAVINGS" ]; then
  STATUS="$STATUS | RTK: $RTK_SAVINGS saved"
fi

echo "$STATUS"
