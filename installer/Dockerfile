FROM docker.kunggame.com/kunggame/vector-model:latest AS vector-model
FROM node:18-alpine3.20 AS web-build
ENV NODE_OPTIONS="--max-old-space-size=8192"
COPY ui ui
RUN cd ui && \
    npm install && \
    npm run build-only && \
    rm -rf ./node_modules
# Python 环境
FROM python:3.11-slim-bullseye AS stage-build

ARG DEPENDENCIES="python3-pip gettext"

RUN apt-get update && \
    apt-get install -y --no-install-recommends $DEPENDENCIES && \
    apt-get clean all  && \
    rm -rf /var/lib/apt/lists/*

COPY . /opt/maxkb/app
RUN mkdir -p /opt/maxkb/app /opt/maxkb/model /opt/maxkb/conf && \
    rm -rf /opt/maxkb/app/ui

COPY --from=web-build ui /opt/maxkb/app/ui
WORKDIR /opt/maxkb/app
RUN python3 -m venv /opt/py3 && \
    pip install poetry==1.8.5 --break-system-packages && \
    poetry config virtualenvs.create false && \
    . /opt/py3/bin/activate && \
    if [ "$(uname -m)" = "x86_64" ]; then sed -i 's/^torch.*/torch = {version = "^2.2.1+cpu", source = "pytorch"}/g' pyproject.toml; fi && \
    poetry install && \
    export MAXKB_CONFIG_TYPE=ENV && python3 /opt/maxkb/app/apps/manage.py compilemessages

FROM python:3.11-slim-bullseye AS runtime

RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean all  && \
    rm -rf /var/lib/apt/lists/*

ENV MAXKB_VERSION="v1.0.0" \
    MAXKB_CONFIG_TYPE=YML \
    LANG=en_US.UTF-8 \
    PATH=/opt/py3/bin:$PATH \
    PIP_TARGET=/opt/maxkb/app/sandbox/python-packages \
    PYTHONPATH=/opt/maxkb/app/sandbox/python-packages \
    PYTHONUNBUFFERED=1

WORKDIR /opt/maxkb/app
COPY --from=stage-build /opt/maxkb /opt/maxkb
COPY --from=stage-build /opt/py3 /opt/py3
COPY --from=vector-model /opt/maxkb/app/model /opt/maxkb/model

RUN chmod 755 /opt/maxkb/app/installer/run-maxkb.sh && \
    cp -r /opt/maxkb/model/base/hub /opt/maxkb/model/tokenizer && \
    cp -f /opt/maxkb/app/installer/run-maxkb.sh /usr/bin/run-maxkb.sh && \
    curl -L --connect-timeout 120 -m 1800 https://resource.fit2cloud.com/maxkb/ffmpeg/get-ffmpeg-linux | sh && \
    mkdir -p /opt/maxkb/app/sandbox/python-packages &&  \
    find /opt/maxkb/app -mindepth 1 -not -name 'sandbox' -exec chmod 700 {} + && \
    chmod 755 /tmp && \
    useradd --no-create-home --home /opt/maxkb/app/sandbox sandbox -g root && \
    chown -R sandbox:root /opt/maxkb/app/sandbox && \
    chmod g-x /usr/local/bin/* /usr/bin/* /bin/* /usr/sbin/* /sbin/* && \
    chmod g+x /usr/local/bin/python* /bin/sh

EXPOSE 8080

ENTRYPOINT ["bash", "-c"]
CMD [ "/usr/bin/run-maxkb.sh" ]
