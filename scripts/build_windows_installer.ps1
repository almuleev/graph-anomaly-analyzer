param(
    [Parameter(Mandatory = $false)]
    [string]$Version = "0.2.0",

    [Parameter(Mandatory = $false)]
    [string]$PythonExe = "python",

    [Parameter(Mandatory = $false)]
    [switch]$SkipInstaller
)

$ErrorActionPreference = "Stop"

function Write-ArtifactHash {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $hash = Get-FileHash -Algorithm SHA256 -LiteralPath $Path
    $hashPath = "$Path.sha256"
    "{0}  {1}" -f $hash.Hash, $Path | Set-Content -Encoding ascii -Path $hashPath
    Write-Host "SHA256 checksum saved: $hashPath"
}

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $projectRoot

$bundleName = "graph-anomaly-analyzer"
$portableDir = Join-Path $projectRoot "dist\windows\$bundleName"
$portableZip = Join-Path $projectRoot "dist\graph-anomaly-analyzer-windows-v$Version.zip"
$installerOutput = Join-Path $projectRoot "dist\graph-anomaly-analyzer-setup-v$Version.exe"
$innoScriptPath = Join-Path $projectRoot "installer\windows\graph-anomaly-analyzer.iss"

if (Test-Path -LiteralPath $portableDir) {
    Remove-Item -LiteralPath $portableDir -Recurse -Force
}
if (Test-Path -LiteralPath (Join-Path $projectRoot "build")) {
    Remove-Item -LiteralPath (Join-Path $projectRoot "build") -Recurse -Force
}
if (Test-Path -LiteralPath (Join-Path $projectRoot "dist\$bundleName")) {
    Remove-Item -LiteralPath (Join-Path $projectRoot "dist\$bundleName") -Recurse -Force
}
if (Test-Path -LiteralPath $portableZip) {
    Remove-Item -LiteralPath $portableZip -Force
}
if (Test-Path -LiteralPath "$portableZip.sha256") {
    Remove-Item -LiteralPath "$portableZip.sha256" -Force
}
if (Test-Path -LiteralPath $installerOutput) {
    Remove-Item -LiteralPath $installerOutput -Force
}
if (Test-Path -LiteralPath "$installerOutput.sha256") {
    Remove-Item -LiteralPath "$installerOutput.sha256" -Force
}

try {
    & $PythonExe --version | Out-Null
}
catch {
    throw "Cannot run Python executable '$PythonExe'."
}

try {
    & $PythonExe -m PyInstaller --version | Out-Null
}
catch {
    throw "PyInstaller is not available. Install it with: pip install pyinstaller"
}

$pyInstallerArgs = @(
    "-m", "PyInstaller",
    "--noconfirm",
    "--clean",
    "--onedir",
    "--name", $bundleName,
    "--collect-data", "streamlit",
    "--copy-metadata", "streamlit",
    "--collect-data", "plotly",
    "--copy-metadata", "plotly",
    "--collect-data", "sklearn",
    "--copy-metadata", "scikit-learn",
    "--collect-submodules", "streamlit",
    "--collect-submodules", "plotly",
    "--collect-submodules", "sklearn.ensemble",
    "--collect-submodules", "sklearn.tree",
    "--collect-submodules", "sklearn.utils",
    "--hidden-import", "pyarrow",
    "--hidden-import", "pyarrow.lib",
    "--hidden-import", "sklearn.ensemble._iforest",
    "--hidden-import", "sklearn.ensemble._forest",
    "--exclude-module", "torch",
    "--exclude-module", "torchaudio",
    "--exclude-module", "torchvision",
    "--exclude-module", "onnxruntime",
    "--exclude-module", "cv2",
    "--exclude-module", "av",
    "--exclude-module", "imageio_ffmpeg",
    "--add-data", "app;app",
    "--add-data", "data;data",
    "--add-data", "models;models",
    "--add-data", "reports;reports",
    "--add-data", "README.md;.",
    "--add-data", "README.ru.md;.",
    "app_launcher.py"
)

Write-Host "Building Windows bundle with PyInstaller..."
& $PythonExe @pyInstallerArgs

$pyInstallerDist = Join-Path $projectRoot "dist\$bundleName"
if (-not (Test-Path -LiteralPath $pyInstallerDist)) {
    throw "PyInstaller output was not found: $pyInstallerDist"
}

New-Item -ItemType Directory -Path (Split-Path -Parent $portableDir) -Force | Out-Null
try {
    Move-Item -LiteralPath $pyInstallerDist -Destination $portableDir -Force
}
catch {
    Write-Warning "Move failed, fallback to copy: $($_.Exception.Message)"
    if (Test-Path -LiteralPath $portableDir) {
        Remove-Item -LiteralPath $portableDir -Recurse -Force
    }
    Copy-Item -LiteralPath $pyInstallerDist -Destination $portableDir -Recurse -Force
}

$launchScriptPath = Join-Path $portableDir "launch-ui.cmd"
@'
@echo off
start "" "%~dp0graph-anomaly-analyzer.exe"
'@ | Set-Content -Encoding ascii -Path $launchScriptPath

Write-Host "Creating portable zip..."
Compress-Archive -Path $portableDir -DestinationPath $portableZip -CompressionLevel Optimal -Force
Write-ArtifactHash -Path $portableZip

if ($SkipInstaller) {
    Write-Host "SkipInstaller is set. Portable bundle is ready: $portableZip"
    exit 0
}

if (-not (Test-Path -LiteralPath $innoScriptPath)) {
    throw "Inno Setup script was not found: $innoScriptPath"
}

$isccCommand = Get-Command "iscc" -ErrorAction SilentlyContinue
if ($null -eq $isccCommand) {
    throw "Inno Setup Compiler (iscc) is not installed or not in PATH. Install Inno Setup or use -SkipInstaller."
}

Write-Host "Building setup installer with Inno Setup..."
& $isccCommand.Source "/DAppVersion=$Version" "/DDistDir=$portableDir" $innoScriptPath

if (-not (Test-Path -LiteralPath $installerOutput)) {
    throw "Installer file was not created: $installerOutput"
}

Write-ArtifactHash -Path $installerOutput
Write-Host "Windows installer build is complete."
