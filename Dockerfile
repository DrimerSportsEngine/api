FROM python:3.10.2

ENV HELM_VERSION=3.8.0

RUN apt-get update && apt-get upgrade -y && \
  apt-get install --no-install-recommends -y make wget && \
  rm -rf /var/lib/apt/lists/*
RUN apt-get install gcc

RUN wget --no-verbose https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
  tar xfv helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
  mv linux-amd64/helm /usr/local/bin/ && \
  mkdir --parents --mode=777 /.config/helm && \
  HOME=/ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts && \
  rm -rf helm-v${HELM_VERSION}-linux-amd64.tar.gz linux-amd64

COPY requirements.txt /usr/src/app/
RUN pip install --no-binary pyuwsgi pyuwsgi
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt

COPY . /usr/src/app

EXPOSE 8000
ENV FLASK_APP=/usr/src/app/src/wsgi.py
CMD uwsgi --http 0.0.0.0:8000 --master -p 1 --pythonpath /usr/src/app/src/ -w wsgi:app
