#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$APP_DIR"

# Get the status of the git repository
CHANGES=$(git status --porcelain)

# Check if there are any changes
if [[ -n "$CHANGES" ]]; then
  echo "🚨 SECURITY ALERT: Git integrity check failed"
  echo
  echo "Host: $(hostname)"
  echo "Path: $APP_DIR"
  echo "Time: $(date -u)"
  echo
  echo "Changed files:"

  # Check if the change is in a submodule, and ignore it if it is
  while IFS= read -r line; do
    # If the change is in a submodule (e.g., "M submodule_name")
    if [[ "$line" =~ ^[A-Z]\s+security ]]; then
      echo "Submodule 'security' change detected, ignoring..."
      continue
    fi
    echo "$line"
  done <<< "$CHANGES"

  # If there are any changes left (after ignoring submodule changes), exit with an error
  if [[ -n "$(echo "$CHANGES" | grep -v '^M security')" ]]; then
    exit 1
  fi
fi

exit 0
