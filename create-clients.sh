#!/bin/bash

if [ -z "$1" ]; then
    echo Usage: ./"$0" client_name
    exit
fi

cd /etc/openvpn/easy-rsa
. ./vars
export username="$1"

./build-key $username

mkdir -p /home/ubuntu/openvpn-clients/"$username"

cd /etc/openvpn/easy-rsa/keys
cp "$username".crt "$username".key /home/ubuntu/openvpn-clients/"$username"

cd /home/ubuntu/openvpn-clients
cp template.ovpn "$username"

cd /home/ubuntu/openvpn-clients/"$username"

#create ca parameter
echo "<ca>" >> template.ovpn
cat ../ca.crt >> template.ovpn
echo "</ca>" >> template.ovpn

#create cert parameter
echo "<cert>" >> template.ovpn
cat "$username".crt >> template.ovpn
echo "</cert>" >> template.ovpn

#create key parameter
echo "<key>" >> template.ovpn
cat "$username".key >> template.ovpn
echo "</key>" >> template.ovpn

mv template.ovpn "$username".ovpn

cd ..
chown -R ubuntu:ubuntu "$username"