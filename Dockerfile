FROM python:3.13-slim

WORKDIR /app

ENV APP_HOST=0.0.0.0 PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1

COPY requirements.txt .

RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/* \
    && python -m pip install --no-cache-dir --upgrade --force-reinstall \
       "pip>=25.3" "setuptools>=78.1.1" "msgpack>=1.2.1" \
    && python -m pip install --no-cache-dir -r requirements.txt \
    && rm -rf /usr/local/lib/python3.13/site-packages/msgpack-1.1.2.dist-info \
              /usr/local/lib/python3.13/site-packages/setuptools-70.3.0.dist-info

RUN groupadd --gid 10001 app && useradd --uid 10001 --gid 10001 --no-create-home --shell /usr/sbin/nologin app
COPY --chown=10001:10001 app ./app
USER 10001:10001

EXPOSE 8080

CMD ["python", "app/app.py"]
