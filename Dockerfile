FROM alpine:edge
MAINTAINER Roy Xiang <developer@royxiang.me>

ENV LANG C.UTF-8

RUN apk add --update --no-cache ca-certificates

RUN set -ex \
        && apk add --no-cache --virtual .run-deps \
                ffmpeg \
                libmagic \
                python3 \
                py3-numpy \
                py3-pillow

RUN set -ex \
        && apk add --update --no-cache --virtual .fetch-deps \
                wget \
                tar \
        && wget -O EFB-dev.tar.gz "https://github.com/blueset/ehForwarderBot/archive/dev.tar.gz" \
        && mkdir -p /opt/ehForwarderBot/storage \
        && tar -xzf EFB-dev.tar.gz --strip-components=1 -C /opt/ehForwarderBot \
        && rm EFB-dev.tar.gz \
        && apk del .fetch-deps \
        && pip3 install -r /opt/ehForwarderBot/requirements.txt \
        && rm -rf /root/.cache

WORKDIR /opt/ehForwarderBot

CMD ["python3", "main.py"]
