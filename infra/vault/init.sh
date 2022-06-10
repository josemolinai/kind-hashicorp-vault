#!/bin/bash

#./create_cert.sh
kubectl -n vault create secret tls vault-ca-crt --cert ./cert/ca.crt --key ./cert/ca.key

# Install Vault
helm install -n vault  vault hashicorp/vault --values ./config/csi.yaml  --values ./config/global.yaml  --values ./config/injector.yaml  --values ./config/server.yaml  --values ./config/ui.yaml
sleep 10

kubectl -n vault wait --for=jsonpath='{.status.phase}'=Running  pod/vault-0  --timeout=300s
kubectl -n vault wait --for=jsonpath='{.status.readyReplicas}'=1  deployment/vault-agent-injector --timeout=300s

# Initialize and unseal Vault
kubectl exec -n vault vault-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > ./keys/init-keys.json

VAULT_UNSEAL_KEY=$(cat ./keys/init-keys.json | jq -r ".unseal_keys_b64[]")
echo "VAULT_UNSEAL_KEY ${VAULT_UNSEAL_KEY}"  > ./keys/VAULT_UNSEAL_KEY.txt

VAULT_ROOT_TOKEN=$(cat ./keys/init-keys.json | jq -r ".root_token")
echo "VAULT_ROOT_TOKEN ${VAULT_ROOT_TOKEN}" > ./keys/VAULT_ROOT_TOKEN.txt

# Unseal Vault running on the vault-0
kubectl -n vault exec vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY >> ./logs/vault.log
sleep 10

# Login to Vault running on the vault-0
kubectl -n vault exec vault-0 -- vault login $VAULT_ROOT_TOKEN  >> ./logs/vault.log