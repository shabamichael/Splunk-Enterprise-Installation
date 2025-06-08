# Splunk-Enterprise-Installation

This script automates the installation of Splunk Enterprise on a Linux system using configuration parameters defined in [`install/config.cfg`](install/config.cfg).

## Usage

1. **Configure Installation Parameters:**
   - Edit [`install/config.cfg`](install/config.cfg) to set the desired Splunk version, build, installation directory, download URL, user, and password.

2. **Run the Installation Script:**
   ```sh
   cd install
   chmod +x splunkInstallation.sh
   sudo ./splunkInstallation.sh

Collecting workspace informationHere’s a suggested README section for splunkInstallation.sh:

```md
# Splunk Enterprise Installation Script

This script automates the installation of Splunk Enterprise on a Linux system using configuration parameters defined in [`install/config.cfg`](install/config.cfg).

## Usage

1. **Configure Installation Parameters:**
   - Edit [`install/config.cfg`](install/config.cfg) to set the desired Splunk version, build, installation directory, download URL, user, and password.

2. **Run the Installation Script:**
   ```sh
   cd install
   chmod +x splunkInstallation.sh
   sudo ./splunkInstallation.sh
   ```

## What the Script Does

- Reads configuration values from [`install/config.cfg`](install/config.cfg)
- Creates the Splunk installation directory if it does not exist
- Creates a Splunk user account if needed
- Downloads the specified Splunk package
- Extracts and installs Splunk to the target directory
- Sets permissions and enables Splunk to start at boot

## Notes

- Ensure you update the `splunk_password` in [`install/config.cfg`](install/config.cfg) to a secure value before running the script.
- The script must be run with root privileges (`sudo`).

For more details, see the comments in [`install/splunkInstallation.sh`](install/splunkInstallation.sh).
```