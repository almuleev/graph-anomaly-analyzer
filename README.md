# graph-anomaly-analyzer

[English](README.md) | [Русский](README.ru.md)

Python project (FastAPI + Streamlit) for industrial time-series analysis:
unstable-mode detection, short-term forecasting, and report generation.

## Project Status

> Stable MVP. Maintained by a single author on a best-effort basis.
> No formal SLA or guaranteed release cadence.

## Features

- CSV/XLSX ingestion with schema validation and clear errors
- Time-series preprocessing (sorting, deduplication, interpolation, scaling)
- Instability detection (`normal` / `warning` / `unstable`)
- Merge of abnormal windows into event intervals
- Forecasting for selected `sensor_*` with risk scoring
- Text explanations for detected instability intervals
- Streamlit UI, FastAPI endpoints, and HTML/TXT report generation

## Quick Start

### 1) Requirements

- Python 3.10+
- `pip`

### 2) Installation

```bash
python -m venv .venv
# Windows
.venv\Scripts\activate
# Linux/macOS
source .venv/bin/activate

pip install --upgrade pip
pip install -r requirements.txt
```

### 3) Run UI

```bash
python main.py ui
```

Open `http://127.0.0.1:8501`.

### 4) Run API

```bash
python main.py api
```

Swagger docs are available at `http://127.0.0.1:8000/docs`.

### 5) Run CLI analysis

```bash
python main.py analyze --file data/demo_timeseries.csv --sensor sensor_2
```

Generated reports are saved to `reports/`.

## End-User Installation (Windows)

If you do not want to install Python manually:

1. Open the latest GitHub Release.
2. Download `graph-anomaly-analyzer-setup-vX.Y.Z.exe`.
3. Run installer and start the app from desktop/start menu shortcut.

## Input Data Format

```text
timestamp,sensor_1,sensor_2,sensor_3,...
```

- `timestamp` is required
- sensor columns must be numeric or convertible to numeric
- missing values are allowed

## API Endpoints

- `GET /health` - service health check
- `POST /upload` - upload source file and create analysis session
- `POST /analyze` - run analysis for a session
- `GET /results` - full analysis payload
- `GET /forecast` - forecast and risk metadata
- `GET /report` - generate/download report

## Repository Structure

```text
.
|-- app/                  # Core business logic, UI, API
|-- data/                 # Demo datasets
|-- models/               # Local model artifacts (not committed)
|-- reports/              # Local reports (not committed)
|-- tests/                # Automated tests
|-- scripts/              # Utility scripts (including release packaging)
|-- main.py               # CLI/UI/API entry point
|-- requirements.txt
`-- requirements-dev.txt
```

## Development

```bash
pip install -r requirements.txt -r requirements-dev.txt
pytest -q
```

CI is configured in `.github/workflows/ci.yml` and runs dependency install, compile smoke checks, and tests.

## One-Click Windows Build

For non-technical users, publish installer assets in GitHub Releases:

- `graph-anomaly-analyzer-setup-vX.Y.Z.exe` (recommended)
- `graph-anomaly-analyzer-windows-vX.Y.Z.zip` (portable bundle)

Build these assets on Windows:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build_windows_installer.ps1 -Version 0.2.0
```

For stable bundle size, run build in a clean virtual environment with only project dependencies.

If Python is not available as `python` in `PATH`, pass explicit executable:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build_windows_installer.ps1 -Version 0.2.0 -PythonExe "C:\Path\To\python.exe"
```

Requirements for build machine:

- Python 3.10+
- dependencies from `requirements.txt` and `requirements-dev.txt`
- Inno Setup (`iscc` in `PATH`) for `.exe` installer generation

If Inno Setup is not installed yet, you can still build only the portable bundle:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build_windows_installer.ps1 -Version 0.2.0 -SkipInstaller
```

## Collaboration Files

- `LICENSE` (MIT)
- `CONTRIBUTING.md`
- `SECURITY.md`
- issue/PR templates in `.github/`

## Release Packaging

A helper script is provided:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/create_release.ps1 -Version 0.2.0
```

Release archive is generated into `dist/` and is ready to upload to GitHub Release assets.
The script also generates a `*.sha256` checksum file for verification.
