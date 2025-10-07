#!/usr/bin/env pwsh
Param(
    [string]$Python = "python"
)

function Assert-Python {
    param([string]$Interpreter)
    if (-not (Get-Command $Interpreter -ErrorAction SilentlyContinue)) {
        Write-Error "Python 3.10+ is required but '$Interpreter' was not found. Install Python and re-run." -ErrorAction Stop
    }
    $version = & $Interpreter - <<'PY'
import sys
import platform
if sys.version_info < (3, 10):
    raise SystemExit("Python 3.10+ required; detected %s" % platform.python_version())
print(platform.python_version())
PY
    Write-Host "Detected Python $version"
}

function Ensure-Pipx {
    param([string]$Interpreter)
    if (Get-Command pipx -ErrorAction SilentlyContinue) {
        return "pipx"
    }
    Write-Host "Installing pipx..."
    & $Interpreter -m pip install --user --upgrade pip pipx
    & $Interpreter -m pipx ensurepath | Out-Null
    return "pipx"
}

Assert-Python -Interpreter $Python
$env:PATH = "$env:USERPROFILE\AppData\Roaming\Python\Python311\Scripts;$env:USERPROFILE\.local\bin;$env:PATH"
Ensure-Pipx -Interpreter $Python | Out-Null

Write-Host "Installing aiexec via pipx..."
& $Python -m pipx install --force aiexec

Write-Host "`n✅ aiexec installed. If this was your first pipx install, restart PowerShell so the PATH update takes effect."
