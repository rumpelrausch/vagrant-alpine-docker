#!/bin/bash

cat <<EOF
=============
Settin up vagrant user environment
=============
EOF

cat << EOF > /home/vagrant/.bash_profile
# If id command returns zero, you’ve root access.
if [ \$(id -u) -eq 0 ];
then # you are root, set red colour prompt
  PS1="\[\033[01;32m\]\\u@\\h:\\w # \[\033[0m\]"
else # normal
  PS1="[\t \\u@\\h:\\w] $ "
fi

alias ll='ls -l'
EOF

cat << EOF > /home/vagrant/.profile
# If id command returns zero, you’ve root access.
if [ \$(id -u) -eq 0 ];
then # you are root, set red colour prompt
  PS1="\[\033[01;32m\]\\u@\\h:\\w # \[\033[0m\]"
else # normal
  PS1="[\t \\u@\\h:\\w] $ "
fi

alias ll='ls -l'
EOF

echo "vagrant ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
echo "Defaults:vagrant !requiretty" >> /etc/sudoers

chown vagrant:vagrant /home/vagrant/.bash_profile
chown vagrant:vagrant /home/vagrant/.profile
chmod +w /home/vagrant/.profile
chmod +w /home/vagrant/.bash_profile

cat <<EOF >> /home/vagrant/.bash_profile
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
EOF

cat <<EOF
=============
Installing essentials
=============
EOF

apk update
apk add --no-cache iptables

cat <<EOF
=============
Installing docker
=============
EOF

apk add --no-cache docker
addgroup vagrant docker
curl --silent --show-error --no-progress-meter -L --fail https://github.com/docker/compose/releases/download/1.29.1/run.sh -o /usr/bin/docker-compose
chmod +rx /usr/bin/docker-compose
rc-update add docker boot
service docker start
