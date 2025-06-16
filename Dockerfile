FROM python:3.13-slim

WORKDIR /app

RUN apt-get update && \
    apt-get install -y \
        gcc \
        build-essential \
        libpq-dev \
        postgresql-client \
        curl \
        dos2unix \
        libffi-dev \
        libssl-dev \
        dnsutils \
        netbase \
        ca-certificates \
        cron \
        libnss3 \
        libnss3-tools \
        libglib2.0-0 \
        libdbus-1-3 \
        libatk1.0-0 \
        libatk-bridge2.0-0 \
        libcups2 \
        libxkbcommon0 \
        libatspi2.0-0 \
        libxcomposite1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxrandr2 \
        libgbm1 \
        libpango-1.0-0 \
        libcairo2 \
        libasound2 \
    && rm -rf /var/lib/apt/lists/*

ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh

ENV PATH="/root/.local/bin/:$PATH"

COPY pyproject.toml uv.lock ./
RUN uv pip install --system .

COPY . .

RUN python3 -m playwright install chromium

ENV PATH="/usr/local/bin:/usr/bin:/bin:$PATH"
