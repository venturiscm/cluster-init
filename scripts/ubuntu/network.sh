#/bin/bash

NETWORK_DIR="/etc/netplan"
HOSTNAME="$1"
STATIC_IP="$2"

# Validation
if [ -z "$HOSTNAME" ]
then
  echo "Hostname is required to set up network"
  exit 1
fi
if [ -z "$STATIC_IP" ]
then
  echo "Static IP is required to set up network"
  exit 2
fi

GATEWAY_IP="$(sed -r 's/[0-9]+$/1/' <<< $STATIC_IP)"

# Hostname
echo "$HOSTNAME" > /etc/hostname

# Network cleanup
rm -f "$NETWORK_DIR/"*.yaml

# eth0 generation
echo "
network:
 version: 2
 renderer: networkd
 ethernets:
   enp1s0:
     dhcp4: no
     dhcp6: no
     addresses: ["$STATIC_IP/24"]
     gateway4: "$GATEWAY_IP"
     nameservers:
       addresses: [8.8.8.8, 8.8.4.4]
" > "$NETWORK_DIR/enp1s0.yaml"
