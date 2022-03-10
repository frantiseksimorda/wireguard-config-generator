#!/bin/bash
EndPoint="example.com:port"                # Wireguard format ip:port
EndPointPubKey="VerySecretPubKeyxy"
EndPointIpAddress="10.20.0.1"       
DesiredIpaddress=$2
IpAddressMask="/16"
IpAddresses="/etc/wireguard/ipa.txt"

if [[ ! -d "/etc/wireguard/keys" ]]
    then
        mkdir /etc/wireguard/keys
fi
if [[ ! -f "/etc/wireguard/ipa.txt" ]]
    then
        touch /etc/wireguard/ipa.txt
fi

if [ $# -eq 0 ]
  then
    echo "No arguments supplied usage: wg-generate-client-config.sh client_name desired_ipaddress # example desired_ipaddress=10.20.0.1"
    exit 1
else
    cd /etc/wireguard/keys/
    wg genkey | (umask 0077 && tee $1.key) | wg pubkey > $1.pub
    echo -e "[Interface]\nAddress = $EndPointIpAddress$IpAddressMask\nPrivateKey = $(cat $1.key)\n\n[Peer]\nPublicKey = $EndPointPubKey \nAllowedIPs = $DesiredIpaddress$IpAddressMask\nEndpoint = $EndPoint" > $1-wg0.conf
    echo -e "$1,$DesiredIpaddress" >> /etc/wireguard/ipa.txt
fi
