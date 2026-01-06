#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

$SCRIPT_DIR/check-integrity.sh
$SCRIPT_DIR/check-new-php.sh
