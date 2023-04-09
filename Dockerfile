FROM python:3.10-alpine3.17
LABEL maintainer="Tom"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
COPY ./app /app

WORKDIR /app
EXPOSE 8000

RUN python -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    #install docker dependencies - 
    apk add --update --no-cache postgresql-client && \
    # temp drivers here only to install previous deps
    # apk = alpine package manager
    apk add --update --no-cache --virtual .tmp-deps \
        build-base postgresql-dev musl-dev linux-headers && \
    /venv/bin/pip install -r /requirements.txt && \
    # clean up temporary dependencies
    apk del .tmp-deps && \
    # adduser otherwise runs as root user
    adduser --disabled-password --no-create-home app
#    mkdir -p /vol/web/static && \
#    mkdir -p /vol/web/media && \
   # chown -R app:app /vol && \
  #  chmod -R 755 /vol && \
#    chmod -R +x /scripts

ENV PATH="/venv/bin:$PATH"

#login as app user not super user
USER app