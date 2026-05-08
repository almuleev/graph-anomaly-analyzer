# graph-anomaly-analyzer

[English](README.md) | [Русский](README.ru.md)

Python-проект (FastAPI + Streamlit) для анализа технологических временных рядов:
поиск нестабильных режимов, краткосрочный прогноз и генерация отчетов.

## Статус проекта

> Стабильный MVP. Проект поддерживается одним автором в best-effort режиме.
> Формального SLA и гарантированного графика релизов нет.

## Возможности

- Загрузка CSV/XLSX с валидацией структуры и понятными ошибками
- Предобработка временных рядов (сортировка, дедупликация, интерполяция, масштабирование)
- Поиск нестабильности (`normal` / `warning` / `unstable`)
- Объединение аномальных окон в интервалы событий
- Прогноз по выбранному `sensor_*` с оценкой риска
- Текстовые объяснения причин нестабильных интервалов
- Streamlit UI, FastAPI API и генерация HTML/TXT отчетов

## Быстрый старт

### 1) Требования

- Python 3.10+
- `pip`

### 2) Установка

```bash
python -m venv .venv
# Windows
.venv\Scripts\activate
# Linux/macOS
source .venv/bin/activate

pip install --upgrade pip
pip install -r requirements.txt
```

### 3) Запуск UI

```bash
python main.py ui
```

После запуска откройте `http://127.0.0.1:8501`.

### 4) Запуск API

```bash
python main.py api
```

Swagger-документация доступна по адресу `http://127.0.0.1:8000/docs`.

### 5) CLI-анализ

```bash
python main.py analyze --file data/demo_timeseries.csv --sensor sensor_2
```

Сформированные отчеты сохраняются в `reports/`.

## Установка для обычного пользователя (Windows)

Если не хотите вручную ставить Python:

1. Откройте последний GitHub Release.
2. Скачайте `graph-anomaly-analyzer-setup-vX.Y.Z.exe`.
3. Запустите установщик и откройте приложение через ярлык в меню Пуск/на рабочем столе.

## Формат входных данных

```text
timestamp,sensor_1,sensor_2,sensor_3,...
```

- `timestamp` обязателен
- столбцы сенсоров должны быть числовыми или приводимыми к числу
- пропуски допустимы

## API endpoints

- `GET /health` - проверка доступности сервиса
- `POST /upload` - загрузка файла и создание сессии анализа
- `POST /analyze` - запуск анализа для сессии
- `GET /results` - полный результат анализа
- `GET /forecast` - прогноз и метаданные риска
- `GET /report` - генерация/загрузка отчета

## Структура репозитория

```text
.
|-- app/                  # Основная бизнес-логика, UI, API
|-- data/                 # Демо-датасеты
|-- models/               # Локальные артефакты моделей (не коммитятся)
|-- reports/              # Локальные отчеты (не коммитятся)
|-- tests/                # Автотесты
|-- scripts/              # Вспомогательные скрипты (включая сборку релиза)
|-- main.py               # Точка входа CLI/UI/API
|-- requirements.txt
`-- requirements-dev.txt
```

## Разработка

```bash
pip install -r requirements.txt -r requirements-dev.txt
pytest -q
```

CI настроен в `.github/workflows/ci.yml`: установка зависимостей, compile smoke-check и тесты.

## One-Click Windows сборка

Для обычного пользователя публикуйте в GitHub Releases:

- `graph-anomaly-analyzer-setup-vX.Y.Z.exe` (рекомендуется)
- `graph-anomaly-analyzer-windows-vX.Y.Z.zip` (portable-версия)

Сборка артефактов на Windows:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build_windows_installer.ps1 -Version 0.2.0
```

Чтобы размер сборки был стабильным, делайте сборку в чистом виртуальном окружении только с зависимостями проекта.

Если `python` не доступен в `PATH`, передайте явный путь:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build_windows_installer.ps1 -Version 0.2.0 -PythonExe "C:\Path\To\python.exe"
```

Что нужно на машине сборки:

- Python 3.10+
- зависимости из `requirements.txt` и `requirements-dev.txt`
- Inno Setup (`iscc` в `PATH`) для генерации `.exe` установщика

Если Inno Setup пока не установлен, можно собрать только portable-архив:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build_windows_installer.ps1 -Version 0.2.0 -SkipInstaller
```

## Файлы для совместной работы

- `LICENSE` (MIT)
- `CONTRIBUTING.md`
- `SECURITY.md`
- шаблоны issue/PR в `.github/`

## Подготовка релиза

В проект добавлен helper-скрипт:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/create_release.ps1 -Version 0.2.0
```

Архив релиза собирается в `dist/` и готов к загрузке как asset в GitHub Release.
Скрипт также формирует файл контрольной суммы `*.sha256` для проверки целостности.
