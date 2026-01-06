#!/usr/bin/env bash

APP_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$APP_DIR"

# Debugging output to confirm script execution
echo "Running integrity checks!"

# Get the status of the git repository, excluding changes related to the 'security' submodule
CHANGES=$(git status --porcelain | grep -v '^ [ M] security' | tr -d '\r')

# Debugging: Print the result of git status
echo "git status output (after filtering security):"
echo "$CHANGES"

# Check for submodule changes (specifically the 'security' submodule)
SUBMODULE_STATUS=$(git submodule status security)

# Debugging: Print the result of git submodule status
echo "Submodule status:"
echo "$SUBMODULE_STATUS"

# Combine the changes (git status + submodule status) and check if there are any real changes
if [[ -n "$CHANGES" || "$SUBMODULE_STATUS" =~ '^- ' ]]; then
  echo "🚨 SECURITY ALERT: Git integrity check failed"
  exit 1
fi

# If no changes, print success message
echo "No changes detected. Integrity check passed."
exit 0
