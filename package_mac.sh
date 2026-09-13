#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
#  package_mac.sh — build FRIDAY into a double-clickable macOS .app
#
#  Produces a standalone FRIDAY.app (PyInstaller bundle) in dist/ and installs
#  it to ~/Applications. Run from the repository root:
#
#      ./package_mac.sh
#
#  Notes
#  -----
#  * The Info.plist is patched AFTER the build with the Apple usage-description
#    strings. On modern macOS a missing NSMicrophoneUsageDescription makes the
#    system silently deny the microphone (still stream "opens", but you hear
#    pure silence and no prompt is ever shown). The patch below is required.
#  * The bundle is codesigned ad-hoc with the stable identifier
#    com.friday.assistant so the app keeps its own microphone permission entry
#    in System Settings ▸ Privacy & Security instead of inheriting a "Python"
#    identity.
#  * Run the app once and click Allow when macOS asks for the microphone.
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

cd "$(dirname "$0")"

BUNDLE_ID="com.friday.assistant"
APP_NAME="FRIDAY"

echo "▸ Checking build environment…"

if [ ! -d ".venv" ]; then
    echo "▸ Creating virtual environment…"
    python3 -m venv .venv
    .venv/bin/python -m pip install --upgrade pip
    .venv/bin/python -m pip install -r requirements.txt
    .venv/bin/python -m playwright install chromium
fi

PY=".venv/bin/python"

if ! "$PY" -c "import PyInstaller" >/dev/null 2>&1; then
    "$PY" -m pip install pyinstaller
fi

echo "▸ Building bundle with PyInstaller…"
"$PY" -m PyInstaller --noconfirm --clean --windowed \
    --name "$APP_NAME" \
    --osx-bundle-identifier "$BUNDLE_ID" \
    --icon config/friday.icns \
    --add-data face.png:. \
    --add-data config:config \
    --add-data core:core \
    --add-data actions:actions \
    --add-data plugins:plugins \
    --add-data dashboard:dashboard \
    --add-data memory:memory \
    --collect-all playwright \
    --hidden-import pyautogui \
    --hidden-import pyperclip \
    --hidden-import pygetwindow \
    --hidden-import youtube_transcript_api \
    --hidden-import python_pptx \
    --hidden-import openpyxl \
    --hidden-import tinytuya \
    --hidden-import webcolors \
    --hidden-import pydantic \
    main.py

PLIST="dist/$APP_NAME.app/Contents/Info.plist"
echo "▸ Adding privacy usage descriptions to Info.plist…"
/usr/libexec/PlistBuddy "$PLIST" \
    -c "Add :NSMicrophoneUsageDescription string FRIDAY needs the microphone to hear your voice for hands-free control." \
    -c "Add :NSCameraUsageDescription string FRIDAY uses the camera when you ask to see or record the room." \
    -c "Add :NSAppleEventsUsageDescription string FRIDAY controls apps on your Mac when you ask it to." \
    -c "Add :NSSystemAdministrationUsageDescription string FRIDAY adjusts system settings when you ask it to." \
    -c "Add :NSSpeechRecognitionUsageDescription string FRIDAY recognizes spoken commands."

echo "▸ Codesigning (ad-hoc)…"
codesign --force --deep --sign - --identifier "$BUNDLE_ID" "dist/$APP_NAME.app"

echo "▸ Installing to ~/Applications…"
rm -rf "$HOME/Applications/$APP_NAME.app"
cp -R "dist/$APP_NAME.app" "$HOME/Applications/$APP_NAME.app"

echo "✓ Done. Launching FRIDAY – agree to the microphone prompt when asked."
open "$HOME/Applications/$APP_NAME.app"