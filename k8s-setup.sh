#!/bin/bash

# Copyright 2018 The Caicloud Authors All rights reserved.

set -o errexit
set -o nounset

INVENTORY_FILE_NAME=inventory

KUBE_ROOT=$(dirname "{BASH_SOURCE}")
ANSIBLE_DEBS_DIR=${KUBE_ROOT}/ansible-debs


ansible_debs="ansible_2.0.0.2-2kord_all.deb python-jinja2_2.8-1kord_all.deb ieee-data_20150531.1kord_all.deb python-markupsafe_0.23-2build2kord_arm64.deb libyaml-0-2_0.1.6-3kord_arm64.deb  python-netaddr_0.7.18-1kord_all.deb  python-crypto_2.6.1-6kord1.16.04.2_arm64.deb python-paramiko_1.16.0-1kord_all.deb python-ecdsa_0.13-2kord_all.deb python-pkg-resources_20.7.0-1kord_all.deb python-httplib2_0.9.1+dfsg-1kord_all.deb  python-yaml_3.11-3kord1_arm64.deb sshpass.deb"

echo ""
echo "#### Install ansible"
dpkg -i ${KUBE_ROOT}/ansible-debs/*


###close private key check
export ANSIBLE_HOST_KEY_CHECKING=False

#echo ""
#echo "#### 设置免密码认证"
#./addkey.sh


echo ""
echo "#### Make sure your inventory file is correct!"
cat ${INVENTORY_FILE_NAME}

echo "#### update hostname"
ansible-playbook -i ${INVENTORY_FILE_NAME} name.yml

echo ""
echo "#### Setup k8s cluster"
ansible-playbook -i ${INVENTORY_FILE_NAME}  site.yml
