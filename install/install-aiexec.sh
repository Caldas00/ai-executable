#!/usr/bin/env bash
set -euo pipefail

if [[ "${TRACE-}" == "1" ]]; then
  set -x
fi

PYTHON_BIN=${PYTHON:-python3}

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  echo "Error: python3 not found. Install Python 3.10+ and re-run this script." >&2
  exit 1
fi

"$PYTHON_BIN" - <<'PY'
import sys
if sys.version_info < (3, 10):
    version = ".".join(map(str, sys.version_info[:3]))
    raise SystemExit(f"Python 3.10+ required; detected {version}.")
PY

export PATH="$HOME/.local/bin:$PATH"

if ! command -v pipx >/dev/null 2>&1; then
  echo "Installing pipx..."
  "$PYTHON_BIN" -m pip install --user --upgrade pip pipx
  "$PYTHON_BIN" -m pipx ensurepath >/dev/null 2>&1 || true
fi

echo "Installing aiexec via pipx..."
"$PYTHON_BIN" -m pipx install --force aiexec

cat <<'MSG'

✅ aiexec installed.
If this is your first pipx install, open a new terminal so "$HOME/.local/bin" is on your PATH.
Then run: aiexec --help
MSG
