param(
    [Parameter(Mandatory = $false)]
    [string]$Version = "0.2.0"
)

$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $projectRoot

$distDir = Join-Path $projectRoot "dist"
if (-not (Test-Path -LiteralPath $distDir)) {
    New-Item -ItemType Directory -Path $distDir | Out-Null
}

$archiveName = "graph-anomaly-analyzer-v$Version.zip"
$archivePath = Join-Path $distDir $archiveName
if (Test-Path -LiteralPath $archivePath) {
    Remove-Item -LiteralPath $archivePath -Force
}

$releaseItems = @(
    "app",
    "data",
    "models",
    "reports",
    "tests",
    ".github",
    "scripts",
    ".editorconfig",
    ".gitattributes",
    ".gitignore",
    "CHANGELOG.md",
    "CONTRIBUTING.md",
    "LICENSE",
    "main.py",
    "pytest.ini",
    "README.md",
    "README.ru.md",
    "requirements.txt",
    "requirements-dev.txt",
    "SECURITY.md"
)

$existingPaths = @()
foreach ($item in $releaseItems) {
    $resolved = Join-Path $projectRoot $item
    if (Test-Path -LiteralPath $resolved) {
        $existingPaths += $resolved
    }
    else {
        Write-Warning "Skip missing item: $item"
    }
}

Compress-Archive -Path $existingPaths -DestinationPath $archivePath -CompressionLevel Optimal -Force
$hash = Get-FileHash -Algorithm SHA256 -LiteralPath $archivePath
$hashPath = Join-Path $distDir "graph-anomaly-analyzer-v$Version.sha256"
"{0}  {1}" -f $hash.Hash, $archivePath | Set-Content -Encoding ascii -Path $hashPath

Write-Host "Release archive created: $archivePath"
Write-Host "SHA256 checksum saved: $hashPath"
