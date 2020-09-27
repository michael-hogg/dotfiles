#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

echo "Starting Configuration..."

echo "Configuring dotfiles..."
cd ./home || exit

find * -type d -exec mkdir -p $HOME/.{} \;
find * -type f -exec ln -sf $PWD/{} $HOME/.{} \;

echo "Configuring packages..."
brew update
brew bundle install --global
brew bundle cleanup --force --global

echo "Configuring SSH..."
ssh_key=$HOME/.ssh/id_rsa
rm -f ${ssh_key}.pub ${ssh_key}.pem
curl -sS 'https://github.com/michael-hogg.keys' -o  ${ssh_key}.pub
ssh-keygen -f ${ssh_key}.pub -e -m pem > ${ssh_key}.pem
chmod 400 ${ssh_key}.pub ${ssh_key}.pem

echo "Configuring additional..."
vim_home=$HOME/.vim
mkdir -p ${vim_home}/swap
mkdir -p ${vim_home}/undo

echo "Done!"
