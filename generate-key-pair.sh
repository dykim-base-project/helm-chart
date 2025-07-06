#!/bin/zsh

ssh-keygen -t rsa -b 2048 -f id_rsa -N ""
kubectl create secret generic ssh-key-secret \
  --from-file=id_rsa=id_rsa \
  --from-file=id_rsa.pub=id_rsa.pub \
  --namespace sample \
  --dry-run=client -o yaml > templates/secret.yaml
