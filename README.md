<div align="center">

# Razcode Build (`razcode-build`)

**Razcode Build** is a powerful, open, multi-provider terminal coding agent.

It runs as a full-screen TUI that understands your codebase, edits files, executes shell commands, searches the web, manages long-running tasks, and works with **local Ollama models**, [Token Harbor](https://tokenharbor.ai), xAI Grok, Anthropic Claude, OpenAI, and any OpenAI-compatible API.

</div>

---

> **Current status of this repository**
> This is a **partial snapshot** of documentation, installer scripts, shared type definitions, and configuration templates. The full multi-crate Rust source tree (`crates/codegen/xai-grok-*`) is added when a complete local checkout is available.

---

## Why Razcode Build?

- **Local-first**: Run completely offline / private with Ollama (or any local OpenAI-compatible server).
- **Multi-provider**: Ollama, Token Harbor (one key, many models), xAI, Anthropic, OpenAI, and custom endpoints.
- **Full agent loop**: Plan mode, diffs, tools, subagents, MCP servers, skills, hooks, memory, and sandboxing.

The user-facing command is **`razcode-build`** so it does not collide with the separate Python `razcode` app.

---

## Authentication

| Provider | Env var | Base URL |
|---|---|
| Ollama (local) | none | `http://localhost:11434/v1` |
| **Token Harbor** | `TOKENHARBOR_API_KEY` | `https://tokenharbor.ai/v1` |
| xAI | `XAI_API_KEY` | `https://api.x.ai/v1` |
| Anthropic | `ANTHROPIC_API_KEY` | `https://api.anthropic.com` |
| OpenAI | `OPENAI_API_KEY` | `https://api.openai.com/v1` |

**Never put API keys in git.** See [TOKENHARBOR.md](TOKENHARBOR.md) for the Windows setup.

Default Token Harbor model: `th-orchestra` (`/model th-orchestra`).

---

## Configuration

Primary config: **`~/.razcode/config.toml`**  
Grok Build still also reads **`~/.grok/config.toml`**.

Template: [`config.multi-provider.toml`](config.multi-provider.toml)

---

## License

Apache License 2.0 — see [LICENSE](LICENSE).

Razcode Build is a community-oriented fork and rebrand of the open-sourced Grok Build harness, extended for first-class multi-provider and local-first usage.
