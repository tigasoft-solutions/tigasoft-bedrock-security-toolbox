#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$APP_DIR"

NEW_PHP=$(find web -type f -name "*.php" -mtime -1 \
  ! -path "./vendor/*" \
  ! -path "./web/wp/*")

if [[ -n "$NEW_PHP" ]]; then
  echo "🚨 SECURITY ALERT: New PHP files detected"
  echo
  echo "Host: $(hostname)"
  echo "Path: $APP_DIR"
  echo "Time: $(date -u)"
  echo
  echo "$NEW_PHP"
  exit 1
fi

exit 0
