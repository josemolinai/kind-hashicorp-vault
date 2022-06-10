#!/bin/bash

# Uninstall Vault
helm uninstall -n vault  vault 

# Delete persistence volumen clain
kubectl -n vault delete  persistentvolumeclaims data-vault-0
kubectl -n vault delete  persistentvolumeclaims data-vault-1
kubectl -n vault delete  persistentvolumeclaims data-vault-2

