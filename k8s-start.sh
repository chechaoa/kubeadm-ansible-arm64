#!/bin/bash

set -o errexit
set -o nounset

INVENTORY_FILE_NAME=inventory


echo ""
echo "#### Make sure your inventory file is correct!"
cat ${INVENTORY_FILE_NAME}

echo ""
echo "#### Destory k8s cluster"
ansible-playbook -i ${INVENTORY_FILE_NAME}  kube-start.yml

