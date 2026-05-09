# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-05-08

### Added

- Russian documentation entrypoint `README.ru.md` with full quick-start parity.
- Release packaging helper script `scripts/create_release.ps1` that builds a clean zip archive in `dist/`.
- Lightweight GitHub templates for bug reports, feature requests, and pull requests.
- Windows launcher entrypoint `app_launcher.py` for one-click UI startup.
- Build script `scripts/build_windows_installer.ps1` for portable bundle and setup installer artifacts.
- Inno Setup template `installer/windows/graph-anomaly-analyzer.iss`.

### Changed

- Reworked README documentation to an English-first format and added a Russian mirror.
- Added language switch links between English and Russian README versions.
- Kept a minimal collaboration baseline for GitHub (`LICENSE`, `CONTRIBUTING.md`, `SECURITY.md`, CI workflow).
- Expanded developer dependencies with `pyinstaller` for Windows release builds.
- Updated Windows launcher behavior to avoid opening duplicate browser tabs.

### Removed

- Deleted an unused helper function in Streamlit UI module to keep the codebase clean.
- Removed non-essential governance files for this small project (`CODE_OF_CONDUCT.md`, `SUPPORT.md`, `NOTICE`).

## [0.1.0] - 2026-04-30

### Added

- Public repository bootstrap documentation (`LICENSE`, `SECURITY`, `CONTRIBUTING`, issue/PR templates).
- GitHub Actions CI workflow with dependency install, smoke compile check and tests.
- Basic automated tests for loader validation and analysis pipeline smoke scenario.

### Changed

- Expanded `.gitignore` for local artifacts and development caches.
- Updated `README.md` with reproducible quick start and development sections.
- Repaired corrupted user-facing error messages in forecast module.
