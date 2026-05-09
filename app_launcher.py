from __future__ import annotations

import os
import socket
import sys
import threading
import time
import webbrowser
from pathlib import Path

import streamlit.web.cli as stcli


DEFAULT_HOST = '127.0.0.1'
DEFAULT_PORT = 8501
PORT_SCAN_LIMIT = 30


def _runtime_root() -> Path:
    if getattr(sys, 'frozen', False) and hasattr(sys, '_MEIPASS'):
        return Path(getattr(sys, '_MEIPASS'))
    return Path(__file__).resolve().parent


def _is_port_busy(host: str, port: int) -> bool:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as probe:
        probe.settimeout(0.2)
        return probe.connect_ex((host, port)) == 0


def _pick_port(host: str, preferred_port: int) -> int:
    for port in range(preferred_port, preferred_port + PORT_SCAN_LIMIT):
        if not _is_port_busy(host, port):
            return port
    raise RuntimeError(
        f'Cannot find a free local port in range {preferred_port}-{preferred_port + PORT_SCAN_LIMIT - 1}.'
    )


def _open_browser(url: str) -> None:
    time.sleep(1.5)
    webbrowser.open(url, new=2)


def main() -> None:
    root_dir = _runtime_root()
    ui_script = root_dir / 'app' / 'ui.py'
    if not ui_script.exists():
        raise SystemExit(f'Cannot find UI script: {ui_script}')

    host = os.environ.get('GAA_HOST', DEFAULT_HOST)
    port_env = os.environ.get('GAA_PORT', str(DEFAULT_PORT))
    try:
        preferred_port = int(port_env)
    except ValueError as exc:
        raise SystemExit(f'Invalid GAA_PORT value: {port_env}') from exc
    port = _pick_port(host=host, preferred_port=preferred_port)

    app_url = f'http://{host}:{port}'
    threading.Thread(target=_open_browser, args=(app_url,), daemon=True).start()

    sys.argv = [
        'streamlit',
        'run',
        str(ui_script),
        '--server.address',
        host,
        '--server.port',
        str(port),
        '--server.headless',
        'true',
        '--global.developmentMode',
        'false',
        '--browser.gatherUsageStats',
        'false',
    ]
    raise SystemExit(stcli.main())


if __name__ == '__main__':
    main()
