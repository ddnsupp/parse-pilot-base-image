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
    && rm -rf /var/lib/apt/lists/*

ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh

ENV PATH="/root/.local/bin/:$PATH"

COPY pyproject.toml uv.lock ./
RUN uv pip install --system .

COPY . .

RUN python3 -m playwright install chromium

ENV PATH="/usr/local/bin:/usr/bin:/bin:$PATH"
