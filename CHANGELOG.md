# Razcode Build Changelog

## v1.0.0 — Multi-Provider & Local-First Release

### Highlights
- Full multi-provider support documented and configured out of the box:
  - **Ollama** (local + cloud)
  - **xAI Grok**
  - **Anthropic Claude** (Messages API)
  - **OpenAI**
  - DeepSeek, Groq, Together, and any OpenAI-compatible endpoint
- New `install-local.sh` for easy local installation from source
- Starter `~/.razcode/config.toml` with ready-to-use model definitions
- Comprehensive `examples/config.multi-provider.toml`
- Updated documentation and branding for Razcode Build
- Apache-2.0 license retained

### Architecture notes
The agent already supported custom `base_url`, `api_backend` (`chat_completions` | `responses` | `messages`), `env_key`, and `extra_headers`.  
This release makes those capabilities first-class with examples, defaults, and an install path optimized for local Ollama + cloud providers.

### Binary name
Installed as `razcode` (compatibility symlink `grok` may also be created).
