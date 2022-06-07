#!/bin/bash

INSTALL_TMP_DIR="/tmp/debian11-install"
GIT_BRANCH=$1
[[ -z "$GIT_BRANCH" ]]&&GIT_BRANCH="main"

########################
### for servers without sshd service
[[ -f "/etc/ssh/ssh_host_ecdsa_key" ]]||ssh-keygen -A
[[ -d "/run/sshd" ]]||mkdir -p /run/sshd

sed -i 's/deb cdrom/#deb cdrom/' /etc/apt/sources.list
apt update
apt install ansible git sshpass vim python3-mysqldb gnupg2 -y

### Make sure target directory exists and empty
mkdir -p $INSTALL_TMP_DIR
cd $INSTALL_TMP_DIR
[ -d "./test-debian11-hardening" ] && rm -rf ./test-debian11-hardening
git clone -b $GIT_BRANCH https://github.com/nelf58/test-debian11-hardening.git

cd test-debian11-hardening/ansible/
git checkout $GIT_BRANCH

export ANSIBLE_ROLES_PATH="$INSTALL_TMP_DIR/test-debian11-hardening/ansible/roles/"
# ansible-galaxy install -r roles/requirements.yml

ansible-playbook --connection=local $INSTALL_TMP_DIR/test-debian11-hardening/ansible/playbooks/debian11_infrastructure.yml -i 127.0.0.1, -v 
