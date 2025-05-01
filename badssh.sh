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

    # Get the most recent log entry for this IP on port 22
    log_line=$(grep "BLOCK" /var/log/ufw.log | grep "DPT=22" | grep "SRC=$ip" | tail -n 1)

    # Extract date and time from the log line
    datetime=$(echo "$log_line" | awk '{print $1, $2, $3}')
    echo "🕒 Attempt Time: $datetime"

    # Get geolocation
    location=$(geoiplookup $ip | awk -F ': ' '{print $2}')
    echo "🌍 Location: $location"

    # Count number of hops using traceroute
    hops=$(traceroute -m 30 -q 1 -w 1 $ip 2>/dev/null | grep -v traceroute | wc -l)
    echo "↕️ Hops: $hops"
done

# Get today's date in syslog format (e.g., "May 01")
today=$(date '+%b %d')

# Count total blocked attempts on port 22 today
total_today=$(grep "$today" /var/log/ufw.log | grep 'BLOCK' | grep 'DPT=22' | wc -l)

echo -e "\n📊 Total SSH block attempts today ($today): $total_today"

