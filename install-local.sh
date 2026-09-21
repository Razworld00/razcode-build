#!/usr/bin/env bash
#
# Razcode Build — local installer (enhanced for local Ollama first-run)
#
# Usage:
#   ./install-local.sh                  # build if needed + install
#   ./install-local.sh --from-source    # always rebuild
#   ./install-local.sh --bin-dir ~/bin  # custom install location
#
set -euo pipefail

VERSION="1.0.1"
BIN_NAME="razcode"
DEFAULT_BIN_DIR="${HOME}/.local/bin"
BIN_DIR="${RAZCODE_BIN_DIR:-$DEFAULT_BIN_DIR}"
FROM_SOURCE=false
CONFIG_DIR="${HOME}/.razcode"
COMPAT_CONFIG_DIR="${HOME}/.grok"
OLLAMA_HOST="${OLLAMA_HOST:-http://localhost:11434}"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info()  { echo -e "${BLUE}==>${NC} $*"; }
ok()    { echo -e "${GREEN}✓${NC} $*"; }
warn()  { echo -e "${YELLOW}!${NC} $*"; }
err()   { echo -e "${RED}✗${NC} $*" >&2; }

usage() {
  cat <<HELP
Razcode Build local installer v${VERSION}

Options:
  --from-source     Force cargo build from this tree
  --bin-dir DIR     Installation directory (default: ~/.local/bin)
  -h, --help        Show this help
HELP
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --from-source) FROM_SOURCE=true; shift ;;
    --bin-dir)     BIN_DIR="$2"; shift 2 ;;
    -h|--help)     usage; exit 0 ;;
    *)             err "Unknown option: $1"; usage; exit 1 ;;
  esac
done

mkdir -p "$BIN_DIR" "$CONFIG_DIR"

# ---------------------------------------------------------------------------
# 0. Pre-flight: Ollama
# ---------------------------------------------------------------------------
info "Checking Ollama..."
if command -v ollama >/dev/null 2>&1; then
  if curl -sf "${OLLAMA_HOST}/api/tags" >/dev/null 2>&1; then
    ok "Ollama is running at ${OLLAMA_HOST}"
    # Show available models briefly
    ollama list 2>/dev/null | head -20 || true
  else
    warn "Ollama CLI found but daemon not reachable at ${OLLAMA_HOST}"
    warn "Start it with:  ollama serve   (or open the Ollama app)"
  fi
else
  warn "Ollama not found in PATH. Install from https://ollama.com for local models."
fi

# ---------------------------------------------------------------------------
# 1. Build or locate binary
# ---------------------------------------------------------------------------
BINARY=""
if [[ "$FROM_SOURCE" == true ]] || [[ ! -x "./target/release/xai-grok-pager" ]]; then
  if ! command -v cargo >/dev/null 2>&1; then
    err "Rust / cargo not found. Install from https://rustup.rs then re-run with --from-source"
    exit 1
  fi
  info "Building Razcode from source (this can take several minutes)…"
  cargo build -p xai-grok-pager-bin --release
  BINARY="./target/release/xai-grok-pager"
else
  BINARY="./target/release/xai-grok-pager"
  info "Using existing release binary"
fi

if [[ ! -x "$BINARY" ]]; then
  err "Binary not found at $BINARY"
  exit 1
fi

# ---------------------------------------------------------------------------
# 2. Install binary as `razcode`
# ---------------------------------------------------------------------------
install -m 755 "$BINARY" "${BIN_DIR}/${BIN_NAME}"
ok "Installed ${BIN_DIR}/${BIN_NAME}"

# Compatibility symlink so any remaining .grok / grok references still resolve
ln -sfn "${BIN_DIR}/${BIN_NAME}" "${BIN_DIR}/grok" 2>/dev/null || true

# ---------------------------------------------------------------------------
# 3. Write / refresh starter config (never overwrite user changes blindly)
# ---------------------------------------------------------------------------
CONFIG_FILE="${CONFIG_DIR}/config.toml"
EXAMPLE_SRC="$(dirname "$0")/examples/config.multi-provider.toml"

if [[ ! -f "$CONFIG_FILE" ]]; then
  if [[ -f "$EXAMPLE_SRC" ]]; then
    cp "$EXAMPLE_SRC" "$CONFIG_FILE"
    ok "Wrote full multi-provider config → ${CONFIG_FILE}"
  else
    # Fallback minimal config
    cat > "$CONFIG_FILE" << 'CFG'
[models]
default = "gpt-oss-120b-cloud"

[model.gpt-oss-120b-cloud]
model = "gpt-oss:120b-cloud"
base_url = "http://localhost:11434/v1"
name = "GPT-OSS 120B Cloud"
api_backend = "chat_completions"
context_window = 128000
CFG
    ok "Wrote minimal Ollama-first config → ${CONFIG_FILE}"
  fi
else
  info "Existing config found at ${CONFIG_FILE} — leaving untouched"
  info "To reset to the latest template:  cp examples/config.multi-provider.toml ~/.razcode/config.toml"
fi

# Compatibility: make ~/.grok point at ~/.razcode so hard-coded paths still work
if [[ ! -e "${COMPAT_CONFIG_DIR}" ]]; then
  ln -sfn "${CONFIG_DIR}" "${COMPAT_CONFIG_DIR}" 2>/dev/null && \
    ok "Created compatibility link ${COMPAT_CONFIG_DIR} → ${CONFIG_DIR}" || true
elif [[ -L "${COMPAT_CONFIG_DIR}" ]]; then
  ok "Compatibility link ${COMPAT_CONFIG_DIR} already present"
else
  warn "${COMPAT_CONFIG_DIR} exists and is not a symlink — leaving it alone"
fi

# ---------------------------------------------------------------------------
# 4. PATH advice
# ---------------------------------------------------------------------------
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$BIN_DIR"; then
  warn "Add the following to your shell profile (~/.bashrc, ~/.zshrc, …):"
  echo
  echo "  export PATH=\"${BIN_DIR}:\$PATH\""
  echo
fi

# ---------------------------------------------------------------------------
# 5. Done
# ---------------------------------------------------------------------------
echo
ok "Razcode Build ${VERSION} is ready."
echo
echo "  Default model : gpt-oss:120b-cloud  (via Ollama)"
echo "  Config        : ${CONFIG_FILE}"
echo
echo "  Quick start:"
echo "    razcode                     # interactive TUI"
echo "    razcode -p \"Explain this repo\""
echo "    razcode /model              # switch models at runtime"
echo
echo "  All your Ollama models are already registered in the config."
echo "  Switch with /model or edit ${CONFIG_FILE}"
echo
