#!/bin/bash

for e in rsa ecdsa ed25519; do
  if ! [ -f /etc/ssh/ssh_host_${e}_key ]; then
    rm -f /etc/ssh/ssh_host_*_key*
    ssh-keygen -q -A
    break
  fi
done

sed -E -i 's/#?Port 22/Port '$SSHD_PORT'/g' /etc/ssh/sshd_config

echo
echo "SSHD listening on port: $SSHD_PORT"
echo

if [ -n "$ROOT_PW" ]; then
  echo "Setting Root password"
  if [[ "${ROOT_PW:0:3}" == '$6$' ]]; then
    echo "root:$ROOT_PW" | chpasswd -e
  else
    echo "root:$ROOT_PW" | chpasswd
  fi
fi

if [ -n "$JENKINS_PW" ]; then
  echo "Setting Jenkins password"
  if [[ "${JENKINS_PW:0:3}" == '$6$' ]]; then
    echo "jenkins:$JENKINS_PW" | chpasswd -e
  else
    echo "jenkins:$JENKINS_PW" | chpasswd
  fi
fi
