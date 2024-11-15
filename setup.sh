#!/bin/bash

SERVICE_FILE="temp_monitor.service"
SCRIPT_FILE="temp_monitor.sh"
SERVICE_PATH="/etc/systemd/system/$SERVICE_FILE"

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or use sudo."
    exit 1
fi

# Give execute permissions
chmod +x $SCRIPT_FILE

# Check command status
check_status() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Get the absolute path to the script
SCRIPT_PATH=$(realpath $SCRIPT_FILE)

# Ask the user for the interval
read -p "Enter the interval in seconds to check the temperature (default is 60 seconds): " USER_INTERVAL
USER_INTERVAL=${USER_INTERVAL:-60}

# Create the service file with the correct path
echo "Creating the service file..."
sudo bash -c "cat > $SERVICE_PATH" <<EOL
[Unit]
Description=Raspberry Pi Temperature Monitor (https://github.com/scoxfield/rpi-temp-monitor)
After=multi-user.target

[Service]
Type=simple
ExecStart=/bin/bash $SCRIPT_PATH $USER_INTERVAL
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOL

check_status "Failed to create the service file."

# Reload the systemd manager configuration
sudo systemctl daemon-reload
check_status "Failed to reload the systemd manager configuration."

# Enable the service to start on boot
sudo systemctl enable $SERVICE_FILE
check_status "Failed to enable the service."

# Start the service
sudo systemctl start $SERVICE_FILE
check_status "Failed to start the service."

echo "Setup complete. The temperature monitor service is now running. :)"
