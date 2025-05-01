# 🚫 Bad SSH Attempts Monitor

This script helps you track and analyze the last 10 unique IP addresses that attempted to SSH into your server and were blocked by UFW on port 22. It provides geolocation data, hop count via traceroute, and a daily summary of all such blocked attempts.

---

## 📜 Features

- Extracts the **10 most recent unique IPs** blocked on port 22.
- Shows:
  - ✅ Date and time of attempt  
  - 🌍 IP geolocation  
  - ↕️ Number of traceroute hops  
- 📊 Displays total number of SSH block attempts **today**.
- Designed to be run as `root` for proper access to logs and networking tools.

---

## 🛠 Requirements

Ensure the following packages are installed:

```bash
sudo apt install geoip-bin traceroute
```

UFW must be enabled and logging must be active:

```bash
sudo ufw enable
sudo ufw logging on
```

---

## 🚀 Usage

```bash
sudo ./badssh.sh
```

---

## 📁 Sample Output

```
Getting last 10 unique IPs blocked on port 22...

🛑 IP: 203.0.113.45
🕒 Attempt Time: 2025-05-01 04:32:17
🌍 Location: United States, CA
↕️ Hops: 12

...

📊 Total SSH block attempts today (2025-05-01): 37
```

---

## ⚠️ Notes

- This script assumes UFW logs are in `/var/log/ufw.log` and use **ISO date format** (`YYYY-MM-DD`).
- If your logs are rotated (`ufw.log.1`, `ufw.log.gz`, etc.), extend the script to use `zgrep`.

---
