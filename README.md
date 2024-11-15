# rpi-temp-monitor

A script that monitors the CPU temperature of a Raspberry Pi and logs system information. If the temperature exceeds a specified threshold, the script logs information about open processes, CPU usage, current temperature, and system uptime, and then shuts down the Raspberry Pi to prevent overheating.

## Background

This mini project was started because I don't have a fan or a heatsink for my Raspberry Pi processor, and I don't want it to overheat.

## Setup Instructions

1. **Clone the repository:**

    ```bash
    git clone https://github.com/scoxfield/rpi-temp-monitor
    cd rpi-temp-monitor
    ```

2. **Run the setup script:**

    ```bash
    sudo ./setup.sh
    ```

    During the setup, you will be prompted to enter the interval (in seconds) at which the script checks the temperature. If not specified, the default is 60 seconds.

3. **Run the temperature monitor script directly (optional):**

    If you prefer not to use the setup script, you can run the `temp_monitor.sh` script directly with a specified interval:

    ```bash
    ./temp_monitor.sh <interval_in_seconds>
    ```

    Replace `<interval_in_seconds>` with the wanted interval.

## Usage

The temperature monitor service will automatically start on boot and check the temperature at the specified interval. If you need to change the interval, you can modify the service file or rerun the setup script with a new interval.

## Uninstall Instructions

Run the uninstall script to remove the temperature monitor service:

```bash
sudo ./uninstall.sh
```
