# Contributing Guide

Thanks for your interest in improving this project.

## Contribution Model

The repository is maintained by a single author. External contributions are welcome and reviewed on a best-effort basis.

## How to Contribute

1. Open an issue with clear problem context or proposal.
2. Create a focused branch for your change.
3. Add or update tests when behavior changes.
4. Open a pull request with a concise summary of what changed and why.

## Local Setup

```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt -r requirements-dev.txt
pytest -q
```

## Notes

- Keep changes small and easy to review.
- Before production use, run your own QA and security review.
