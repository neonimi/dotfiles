#!/usr/bin/env bash
set -euo pipefail

# Resolve repository root from this script location.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

log() {
  printf '[setup] %s\n' "$1"
}
