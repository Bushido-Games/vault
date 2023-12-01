FROM hashicorp/vault:1.14.2

WORKDIR /vault

COPY ./config ./config

