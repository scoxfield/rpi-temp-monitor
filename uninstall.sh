#!/bin/bash

SERVICE_FILE="temp_monitor.service"
SERVICE_PATH="/etc/systemd/system/$SERVICE_FILE"

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or use sudo."
    exit 1
fi

# Check command status
check_status() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Check if the service file exists
if [ ! -f $SERVICE_PATH ]; then
    echo "Service file does not exist. Nothing to uninstall."
    exit 0
fi

# Stop the service
echo "Stopping the service..."
sudo systemctl stop $SERVICE_FILE
check_status "Failed to stop the service."

# Disable the service
echo "Disabling the service..."
sudo systemctl disable $SERVICE_FILE
check_status "Failed to disable the service."

# Remove the service file
echo "Removing the service file..."
sudo rm $SERVICE_PATH
check_status "Failed to remove the service file."

# Reload the systemd manager configuration
echo "Reloading the systemd manager configuration..."
sudo systemctl daemon-reload
check_status "Failed to reload the systemd manager configuration."

echo "Uninstallation complete. The temperature monitor service has been removed."