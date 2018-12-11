#!/bin/bash

set -o errexit
set -o nounset

INVENTORY_FILE_NAME=inventory

export ANSIBLE_HOST_KEY_CHECKING=False

echo ""
echo "#### Make sure your inventory file is correct!"
cat ${INVENTORY_FILE_NAME}

echo "#### update hostname"
ansible-playbook -i ${INVENTORY_FILE_NAME} name.yml


echo ""
echo "#### Destory k8s cluster"
ansible-playbook -i ${INVENTORY_FILE_NAME}  kube-join.yml

