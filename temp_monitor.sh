#!/bin/bash

# Raspberry Pi Temperature Monitor Script
# https://github.com/scoxfield/rpi-temp-monitor

# Configuration
THRESHOLD=75  # Temp in Celsius
DEFAULT_INTERVAL=60   # Default time in seconds
LOG_FILE="/var/log/temp_monitor.log"

# Checks for a CLI argument otherwise use the default
if [ -n "$1" ]; then
    INTERVAL=$1
else
    INTERVAL=$DEFAULT_INTERVAL
fi

# Log system info if temperature exceeds threshold
log_info() {
    echo "========================================" >> $LOG_FILE
    echo "Temperature exceeded threshold at $(date)" >> $LOG_FILE
    echo "----------------------------------------" >> $LOG_FILE
    echo "Uptime: $(uptime -p)" >> $LOG_FILE
    echo "CPU Temperature: $(vcgencmd measure_temp)" >> $LOG_FILE
    echo "CPU Usage: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/")% idle" >> $LOG_FILE
    echo "Processes:" >> $LOG_FILE
    ps aux >> $LOG_FILE
    echo "========================================" >> $LOG_FILE
    echo "" >> $LOG_FILE
    echo "Memory Usage:" >> $LOG_FILE
    free -h >> $LOG_FILE
    echo "" >> $LOG_FILE
    echo "Disk Usage:" >> $LOG_FILE
    df -h >> $LOG_FILE
}

# Main loop
while true; do
    TEMP=$(vcgencmd measure_temp | grep -o '[0-9.]*')
    if (( $(echo "$TEMP > $THRESHOLD" | bc -l) )); then
        log_info
        wall "Temperature exceeded!!! Current temperature: $TEMP°C, Threshold: $THRESHOLD°C. Shutting down in 1 minute to prevent overheating. Save your work!"
        sudo shutdown -h +1
    fi
    sleep $INTERVAL
done