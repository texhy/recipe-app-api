FROM python:3.9-alpine3.13
LABEL mainainer="londonappdeveloper.com"
ENV PYTHONUNBUFFERED=1



#Copies the req file to the docker image that we are going to create
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt 

COPY ./app /app
EXPOSE 8000
ARG DEV=false

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del build-deps && \
    adduser -D -H django-user

ENV PATH="/py/bin:$PATH"

USER django-user