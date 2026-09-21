<div align="center">

# Razcode Build (`razcode`)

**Razcode Build** is a powerful, open, multi-provider terminal coding agent.

It runs as a full-screen TUI that understands your codebase, edits files, executes shell commands, searches the web, manages long-running tasks, and works with **local Ollama models**, xAI Grok, Anthropic Claude, OpenAI, and any OpenAI-compatible or Anthropic-compatible API.

</div>

---

> **Current status of this repository**  
> This is a **partial snapshot** of the available workspace files (documentation, installer scripts, shared type definitions, and configuration templates). The full multi-crate Rust source tree (crates under `xai-grok-*`) is not present in the source material that was pushed. Further complete source will be added when available.

---

## Why Razcode Build?

- **Local-first**: Run completely offline / private with Ollama (or any local OpenAI-compatible server).
- **Multi-provider**: First-class support for Ollama, xAI, Anthropic, OpenAI, and custom endpoints.
- **Full agent loop**: Plan mode, diffs, tools, subagents, MCP servers, skills, hooks, memory, and sandboxing.
- **Extensible**: Plugins, AGENTS.md project rules, custom models, and the Agent Client Protocol (ACP).

---

## Quick Start (when full source is available)

1. Make sure Ollama is installed and running:
   ```bash
   ollama list
   ```

2. From a complete source tree:
   ```bash
   chmod +x install-local.sh
   ./install-local.sh --from-source
   ```

3. Run:
   ```bash
   razcode
   ```

Default model is **`gpt-oss:120b-cloud`**. Switch models at runtime with `/model`.

---

## Configuration

Primary config location: **`~/.razcode/config.toml`**

A multi-provider template lives at `config.multi-provider.toml` in this repo.

---

## License

Apache License 2.0 — see [LICENSE](LICENSE).

Razcode Build is a community-oriented fork and rebrand of the open-sourced Grok Build harness, extended for first-class multi-provider and local-first usage.
