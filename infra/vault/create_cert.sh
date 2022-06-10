#!/bin/bash

# Generate a Certificate Authority Certificate


rm -fR ./cert/
mkdir -p ./cert/

## Generate a CA certificate private key.
openssl genrsa -out ./cert/ca.key 4096

## Generate the CA certificate.
openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/C=CN/ST=Dev/L=Dev/O=dev/OU=dev/CN=vault.dev.local" \
 -key ./cert/ca.key \
 -out ./cert/ca.crt
