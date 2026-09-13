# 🤖 FRIDAY

**A real-time, voice-controlled AI assistant for your desktop — hands-free,
end to end.**

FRIDAY talks to you out loud, listens to your voice, sees your screen, and can
control your computer: opening apps, browsing the web, setting reminders,
booking flights, running code, and more — all through the **Gemini Live API**
for native two-way audio streaming.

> 🔊 Say *"Hey Jarvis"* to wake it, or keep it always-on. Yes, the wake word is
> still Jarvis — that's the wake-word model FRIDAY ships with.

---

## ✨ Features

- 🗣️ **Real-time voice conversation** — stream audio back and forth with
  Gemini Live, no push-to-talk needed.
- 👂 **Wake-word detection** — optional hands-free "Hey Jarvis" trigger.
- 🖥️ **Computer control** — open apps, click, type, browse, take screenshots.
- 🔎 **16+ built-in tools** — reminders, flight finder, weather, YouTube, web
  search, WhatsApp / messaging, code helpers, dev-agent and more.
- 📊 **Live HUD** — waveform reacts to your voice while you speak.
- 📱 **Remote control** — control FRIDAY from your phone via its local web
  dashboard.
- 💾 **Memory** — long-term memory of your name, habits and preferences.
- 🔒 **Private by default** — nothing leaves your machine except what you say
  to the LLM; your API key and personal memory are never committed or shared.

---

## 🧰 What you need

| Requirement          | Notes                                                        |
| -------------------- | ------------------------------------------------------------ |
| macOS / Windows / Linux | Tested on macOS; Windows & Linux run from source            |
| Python               | 3.11 – 3.13                                                    |
| A Gemini API key     | [Google AI Studio](https://aistudio.google.com/apikey) — free tier is fine |
| (Optional) Ollama    | Use a local LLM instead of Gemini — see **Local LLMs** below |

---

## 🚀 Quick start (from source)

```bash
git clone https://github.com/YAJATai/FRIDAY.git
cd FRIDAY

python3 -m venv .venv
source .venv/bin/activate          # Windows: .venv\Scripts\activate

pip install -r requirements.txt
playwright install chromium        # for browser automation

cp config/api_keys.example.json config/api_keys.json
# 1. Open config/api_keys.json and paste your Gemini API key
# 2. Keep "os_system": "mac" — or use "windows" / "linux"

python main.py
```

On first launch FRIDAY connects to Gemini Live and starts talking. Scream at it,
then enjoy.

> 💡 **Windows / Linux:** FRIDAY runs identically from source. Only the
> double-clickable `.app` packaging is macOS-specific.

---

## 📦 Install as a macOS app (double-click)

macOS users can build a standalone FRIDAY.app with a single command:

```bash
./package_mac.sh
```

This creates `FRIDAY.app`, installs it to `~/Applications`, and opens it. The
script also bakes in the Apple privacy usage descriptions and codesigns the app
with a stable identifier — **without that, macOS silently blocks the
microphone** (the stream "opens" but you only hear silence and no prompt ever
appears).

First run: click **Allow** when macOS asks *"„FRIDAY" would like to access the
microphone"*. Check it in **System Settings ▸ Privacy & Security ▸
Microphone**.

---

## ⚙️ Configuration (`config/api_keys.json`)

```jsonc
{
  "gemini_api_key": "AIza…",        // your Gemini API key (required for voice)
  "os_system": "mac",               // "mac" | "windows" | "linux" — used by
                                    // computer-control tools to know your OS
  // optional:
  "assistant_name": "FRIDAY",       // what the assistant calls itself
  "user_name": "Tony"               // how FRIDAY addresses you
}
```

### Local LLMs (no Gemini key)

FRIDAY can run fully offline against a local model instead:

```jsonc
{
  "llm_provider": "ollama",         // or "openai"-style servers (LM Studio…)
  "llm_url": "http://localhost:11434",
  "llm_model": "llama3.2"
}
```

---

## 🛠️ Troubleshooting

| Symptom                                            | Fix                                                                 |
| -------------------------------------------------- | ------------------------------------------------------------------- |
| App connects but **never hears you** (silence)     | Mic permission never granted. Rebuild with `./package_mac.sh` and click **Allow** on the prompt; verify in System Settings ▸ Privacy & Security ▸ Microphone. |
| "Rate limit / RESOURCE_EXHAUSTED" from Gemini      | You hit your free-tier quota; wait, upgrade, or switch to Ollama.   |
| "llama3.2" not found                               | Start Ollama (`ollama serve`) and `ollama pull llama3.2`.           |
| Wake word never triggers                           | Make sure wake word is enabled in the UI (it defaults to off).      |
| Browser controls do nothing                        | `playwright install chromium` hasn't been run.                      |

---

## 🤝 Credits & license

FRIDAY is © 2026 **YAJATai** and released under the **MIT License** — use it,
modify it, ship it, even commercially. See [`LICENSE`](LICENSE).

---

Made with ❤️ and a compromised sleep schedule. *"Put on the suit."*