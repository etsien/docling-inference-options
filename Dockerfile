FROM python:3.11-slim-bookworm AS builder
WORKDIR /app

RUN pip install --upgrade pip && \
    pip install poetry && \
    poetry config virtualenvs.in-project true

COPY pyproject.toml poetry.lock /app/
RUN poetry install --no-ansi --with cuda -E cuda

FROM python:3.11-slim-bookworm
WORKDIR /app

COPY --from=builder /app /app
COPY src /app/src

CMD [ "/app/.venv/bin/python", "-m", "src.main" ]
