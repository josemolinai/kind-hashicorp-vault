#!/bin/sh

./preload.sh hashicorp/vault-k8s:0.16.1 hashicorp/vault-k8s:0.16.1
./preload.sh hashicorp/vault:1.10.3 hashicorp/vault:1.10.3
./preload.sh hashicorp/vault-csi-provider:1.1.0 hashicorp/vault-csi-provider:1.1.0
