#!/bin/bash

# Must run as root to access logs and run traceroute
if [[ $EUID -ne 0 ]]; then
   echo "Please run as root (sudo)."
   exit 1
fi

echo "Getting last 10 unique IPs blocked on port 22..."

# Get 10 most recent unique IPs from ufw.log blocked on DPT=22
ips=$(grep 'BLOCK' /var/log/ufw.log | grep 'DPT=22' | grep -oP '(?<=SRC=)[0-9\.]+' | tac | awk '!seen[$0]++' | head -n 10)

if [ -z "$ips" ]; then
    echo "No blocked IPs found on port 22."
    exit 0
fi

for ip in $ips; do
    echo -e "\n🛑 IP: $ip"

    # Get geolocation (install geoip-bin if not present)
    location=$(geoiplookup $ip | awk -F ': ' '{print $2}')
    echo "🌍 Location: $location"

    # Count number of hops using traceroute
    hops=$(traceroute -m 30 -q 1 -w 1 $ip 2>/dev/null | grep -v traceroute | wc -l)
    echo "↕️ Hops: $hops"
done

