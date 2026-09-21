# Token Harbor on Razcode Build

One key (`thk_live_…`) talks to many models through Token Harbor.

**Never commit the key.** Store it only as the environment variable `TOKENHARBOR_API_KEY`.

| Field | Value |
|---|---|
| Base URL | `https://tokenharbor.ai/v1` |
| Env var | `TOKENHARBOR_API_KEY` |
| Default model | `th-orchestra` |

## Windows (PowerShell)

Paste your key once (User scope — survives restarts). Then open a **new** PowerShell window.

```powershell
[System.Environment]::SetEnvironmentVariable(
  "TOKENHARBOR_API_KEY",
  "thk_live_PASTE_YOUR_KEY_HERE",
  "User"
)
```

Append these models to **both**:

- `%USERPROFILE%\.razcode\config.toml`
- `%USERPROFILE%\.grok\config.toml`  (Grok Build still reads this)

```toml
[model.th-orchestra]
model = "th-orchestra"
base_url = "https://tokenharbor.ai/v1"
name = "Token Harbor Orchestra"
env_key = "TOKENHARBOR_API_KEY"
api_backend = "chat_completions"
context_window = 200000

[model.th-deepseek-v4-flash]
model = "deepseek-v4-flash"
base_url = "https://tokenharbor.ai/v1"
name = "DeepSeek V4 Flash (Token Harbor)"
env_key = "TOKENHARBOR_API_KEY"
api_backend = "chat_completions"
context_window = 128000
```

Inside the TUI:

```
/model th-orchestra
```

## Python Razcode

Point an OpenAI-compatible client at the same values:

- `OPENAI_BASE_URL=https://tokenharbor.ai/v1`
- `OPENAI_API_KEY=%TOKENHARBOR_API_KEY%`
- model = `th-orchestra`

## Security

If this key was shown on screen, in chat, or in a screenshot, rotate it at
https://tokenharbor.ai/dashboard after you confirm the app works.
