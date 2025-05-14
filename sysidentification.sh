#!/bin/bash

# a script to display the current hostname, IP address, and gateway IP

# find and display the hostname
echo "Hostname: $(hostname)"

# find and display the ip address (IPV4 address for the primary interface, which is the one that is used to reach the internet)
echo -n "My IP: "
ip r s default | awk '{print $9}'

# find and display the gateway ip (AKA the default route router ip)
echo -n "Default router: "
ip r s default | awk '{print $3}'

