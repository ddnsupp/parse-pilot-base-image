FROM python:3.13-slim AS uv
ENV PATH="/root/.local/bin:$PATH"
WORKDIR /tmp

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update && apt-get install --no-install-recommends -y curl \
    && rm -rf /var/lib/apt/lists/*

ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh

FROM python:3.13-slim
ENV PATH="/root/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
WORKDIR /app

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update && apt-get install --no-install-recommends -y \
        gcc build-essential libffi-dev libssl-dev libpq-dev \
        libpq5 postgresql-client dos2unix dnsutils netbase ca-certificates cron \
        libnss3 libnss3-tools libglib2.0-0 libdbus-1-3 libatk1.0-0 libatk-bridge2.0-0 \
        libcups2 libxkbcommon0 libatspi2.0-0 libxcomposite1 libxdamage1 libxext6 \
        libxfixes3 libxrandr2 libgbm1 libpango-1.0-0 libcairo2 libasound2 curl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=uv /root/.local/bin/uv /usr/local/bin/uv

COPY pyproject.toml uv.lock ./
RUN --mount=type=cache,id=uv-cache,target=/root/.cache/uv \
    uv pip install --system . && rm -rf /root/.cache/uv/*

COPY . .

RUN python -m playwright install chromium && \
    rm -rf /root/.cache/ms-playwright /tmp/*
