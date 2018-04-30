#/bin/bash

NETWORK_DIR="/etc/network/interfaces.d"
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
rm -f "$NETWORK_DIR/"*.cfg

# Localhost generation
echo "
auto lo
iface lo inet loopback
" > "$NETWORK_DIR/localhost"

# eth0 generation
echo "
iface eth0 inet static
address "$STATIC_IP"
gateway "$GATEWAY_IP"
netmask 255.255.255.0

domain_name_servers=8.8.8.8, 8.8.4.4
" > "$NETWORK_DIR/eth0"
