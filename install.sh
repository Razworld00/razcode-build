#!/usr/bin/env bash
# Razcode Build network / convenience installer
# For full control use ./install-local.sh from a source checkout.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -x "${SCRIPT_DIR}/install-local.sh" ]]; then
  exec "${SCRIPT_DIR}/install-local.sh" "$@"
else
  echo "Please extract the full razcode-build source tree and run ./install-local.sh"
  exit 1
fi
