#!/bin/zsh

kubectl get secret -n sample ssh-private-key -o jsonpath="{.data.ssh-privatekey}" | base64 -d > private.pem
chmod 600 private.pem

ssh -i private.pem ubuntu@localhost -p 30222