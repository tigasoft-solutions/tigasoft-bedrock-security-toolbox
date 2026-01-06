#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$APP_DIR"

CHANGES=$(git status --porcelain)

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

exit 0
