#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$APP_DIR"

# Get the status of the git repository, excluding changes related to the 'security' submodule.
# We check for modified files and exclude submodule updates.
CHANGES=$(git status --porcelain | grep -v '^ [ M] security')

# Also exclude changes related to submodule status
SUBMODULE_CHANGES=$(git submodule status | grep -v '^+' | grep -v '^-')

# Combine the changes (git status + submodule status) and check if there are any real changes
if [[ -n "$CHANGES" || -n "$SUBMODULE_CHANGES" ]]; then
  echo "🚨 SECURITY ALERT: Git integrity check failed"
  echo
  echo "Host: $(hostname)"
  echo "Path: $APP_DIR"
  echo "Time: $(date -u)"
  echo
  echo "Changed files:"
  echo "$CHANGES"
  echo
  echo "Submodule changes:"
  echo "$SUBMODULE_CHANGES"
  echo
  exit 1
fi

# If no changes, exit with success
echo "No changes detected. Integrity check passed."
exit 0
