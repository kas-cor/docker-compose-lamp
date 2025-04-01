#!/bin/bash

# Backup /etc/hosts
[ ! -f /etc/hosts.base ] && cat /etc/hosts > /etc/hosts.base

# Refresh /etc/hosts
cat /etc/hosts.base > /etc/hosts
find /tmp/etc-hosts/* -type f -exec sh -c 'echo "# {}"; cat "{}"' \; >> /etc/hosts

# Update & upgrade & autoremove
apt-get update -y --fix-missing
apt-get upgrade -y --fix-missing
apt-get autoremove -y --fix-missing
composer self-update
/root/.bun/bin/bun upgrade

tail -f /dev/null
