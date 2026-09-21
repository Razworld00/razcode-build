<div align="center">

# Razcode Build (`razcode`)

**Razcode Build** is a powerful, open, multi-provider terminal coding agent.

It runs as a full-screen TUI that understands your codebase, edits files, executes shell commands, searches the web, manages long-running tasks, and works with **local Ollama models**, xAI Grok, Anthropic Claude, OpenAI, and any OpenAI-compatible or Anthropic-compatible API.

</div>

---

## Why Razcode Build?

- **Local-first**: Run completely offline / private with Ollama (or any local OpenAI-compatible server).
- **Multi-provider**: First-class support for Ollama, xAI, Anthropic, OpenAI, and custom endpoints.
- **Full agent loop**: Plan mode, diffs, tools, subagents, MCP servers, skills, hooks, memory, and sandboxing.
- **Extensible**: Plugins, AGENTS.md project rules, custom models, and the Agent Client Protocol (ACP).

This repository contains the complete Rust source for the `razcode` CLI/TUI and its agent runtime (derived from the open-sourced Grok Build harness).

---

## Quick Start (Local Ollama – recommended)

1. Make sure Ollama is installed and running:
   ```bash
   ollama list          # should show your models
   ```

2. Install Razcode from this source tree:
   ```bash
   chmod +x install-local.sh
   ./install-local.sh --from-source
   ```

3. Run:
   ```bash
   razcode
   ```

Default model is **`gpt-oss:120b-cloud`**. All models from your `ollama list` are pre-registered.

Switch models at runtime with `/model`.

---

## Installing

### From this source tree (recommended)

```bash
./install-local.sh --from-source
```

The installer will:
- Build the binary
- Install it as `~/.local/bin/razcode`
- Write a complete `~/.razcode/config.toml` with all your Ollama models
- Create a compatibility symlink `~/.grok` → `~/.razcode` so internal paths keep working

### Authentication options

- **Local Ollama** → no key required
- Cloud providers → set the corresponding env vars (`XAI_API_KEY`, `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, …)

---

## Building from source

Requirements:
- Rust 1.94+ (see `rust-toolchain.toml`)
- `protoc`
- Standard C toolchain

```bash
cargo build -p xai-grok-pager-bin --release
./target/release/xai-grok-pager   # or run install-local.sh
```

---

## Configuration

Primary config location: **`~/.razcode/config.toml`**

A full template with every model from your `ollama list` is written by the installer and also lives at:

```
examples/config.multi-provider.toml
```

Key points:
- `api_backend = "chat_completions"` is used for all Ollama models
- `base_url = "http://localhost:11434/v1"` is the standard Ollama OpenAI-compatible endpoint
- Default model is `gpt-oss-120b-cloud`

---

## Project layout (high level)

```
razcode-build/
├── crates/codegen/          # Core agent, TUI, tools, models, config
│   ├── xai-grok-pager-bin/  # Main binary crate
│   ├── xai-grok-agent/      # Agent loop & tool dispatch
│   ├── xai-grok-models/     # Default model registry (updated for Ollama-first)
│   └── …                    
├── install-local.sh         # Local installer (enhanced)
├── examples/                # Ready-to-use multi-provider config
└── README.md
```

> **Note**: Internal crate names remain `xai-grok-*` (layout preserved). The user-facing binary and config are fully `razcode`.

---

## License

Apache License 2.0 — see [LICENSE](LICENSE).

Razcode Build is a community-oriented fork and rebrand of the open-sourced Grok Build harness, extended for first-class multi-provider and local-first usage.
