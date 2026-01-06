#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$APP_DIR"

# Get the status of the git repository (but exclude changes related to the 'security' directory)
CHANGES=$(git status --porcelain | grep -v '^ [ M] security')

# Check for any other changes
if [[ -n "$CHANGES" ]]; then
  echo "🚨 SECURITY ALERT: Git integrity check failed"
  echo
  echo "Host: $(hostname)"
  echo "Path: $APP_DIR"
  echo "Time: $(date -u)"
  echo
  echo "Changed files:"
  echo "$CHANGES"
  echo
  exit 1
fi

# If no changes, exit with success
exit 0
