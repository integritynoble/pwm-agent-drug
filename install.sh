#!/usr/bin/env bash
# pwm-agent-drug installer — one-line install, no root / pipx / system packages.
#
#   curl -fsSL https://raw.githubusercontent.com/integritynoble/pwm-agent-drug/main/install.sh | bash
#
# Creates (or reuses) the shared AI4Science venv under ~/.ai4science and links
# the `pwm-drug` command into ~/.local/bin. Shares the same install home
# as AI4Science on purpose — one PWM identity / login for every agent, not a
# separate silo per package.
#
# Env overrides:
#   AI4SCIENCE_HOME=<dir>   shared install location (default ~/.ai4science)
#   AI4SCIENCE_BIN=<dir>    where to link the command (default ~/.local/bin)
set -euo pipefail

PKG="pwm-agent-drug"
INSTALL_DIR="${AI4SCIENCE_HOME:-$HOME/.ai4science}"
VENV="$INSTALL_DIR/venv"
BIN_DIR="${AI4SCIENCE_BIN:-$HOME/.local/bin}"

say()  { printf '\033[36m▸\033[0m %s\n' "$*"; }
ok()   { printf '\033[32m✓\033[0m %s\n' "$*"; }
die()  { printf '\033[31m✗ %s\033[0m\n' "$*" >&2; exit 1; }

say "Installing $PKG (command: pwm-drug)…"

# 1. Find a Python >= 3.10.
find_python() {
  for c in python3.13 python3.12 python3.11 python3.10 python3 python; do
    command -v "$c" >/dev/null 2>&1 || continue
    "$c" - <<'PYEOF' >/dev/null 2>&1 || continue
import sys
raise SystemExit(0 if sys.version_info[:2] >= (3, 10) else 1)
PYEOF
    echo "$c"; return 0
  done
  return 1
}

PY="$(find_python)" || die "Python >= 3.10 not found on PATH.
   Debian/Ubuntu:  sudo apt install python3 python3-venv
   macOS:          brew install python@3.12
   Or install Python 3.10+ yourself and re-run."
ok "Using $("$PY" --version 2>&1) ($(command -v "$PY"))"

# 2. Shared venv (reuse if AI4Science already created it).
if [ -x "$VENV/bin/python" ]; then
  say "Reusing shared venv at $VENV"
else
  say "Creating shared venv at $VENV"
  "$PY" -m venv "$VENV" || die "could not create venv (is python3-venv available?)"
fi
"$VENV/bin/pip" install --quiet --upgrade pip >/dev/null

# 3. Install the package (also pulls pwm-agent-core once it's a published dist).
say "Installing $PKG…"
"$VENV/bin/pip" install --quiet "$PKG" \
  || die "install failed — check network access to PyPI"
ok "Installed $PKG"

# 4. Expose the command on PATH.
mkdir -p "$BIN_DIR"
ln -sf "$VENV/bin/pwm-drug" "$BIN_DIR/pwm-drug"
ok "Linked $BIN_DIR/pwm-drug"

case ":$PATH:" in
  *":$BIN_DIR:"*) ok "$BIN_DIR already on PATH" ;;
  *) printf '\n\033[33m%s is not on your PATH.\033[0m Add this to your shell rc:\n' "$BIN_DIR"
     printf '    export PATH="%s:$PATH"\n' "$BIN_DIR" ;;
esac

echo
ok "Installed. Run: pwm-drug login  then  pwm-drug"
