# -*- mode: python ; coding: utf-8 -*-
from PyInstaller.utils.hooks import collect_all

datas = [('face.png', '.'), ('config', 'config'), ('core', 'core'), ('actions', 'actions'), ('plugins', 'plugins'), ('dashboard', 'dashboard'), ('memory', 'memory')]
binaries = []
hiddenimports = ['pyautogui', 'pyperclip', 'pygetwindow', 'youtube_transcript_api', 'python_pptx', 'openpyxl', 'tinytuya', 'webcolors', 'pydantic']
tmp_ret = collect_all('playwright')
datas += tmp_ret[0]; binaries += tmp_ret[1]; hiddenimports += tmp_ret[2]


a = Analysis(
    ['main.py'],
    pathex=[],
    binaries=binaries,
    datas=datas,
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='FRIDAY',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=['config/friday.icns'],
)
coll = COLLECT(
    exe,
    a.binaries,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='FRIDAY',
)
app = BUNDLE(
    coll,
    name='FRIDAY.app',
    icon='config/friday.icns',
    bundle_identifier='com.friday.assistant',
)
