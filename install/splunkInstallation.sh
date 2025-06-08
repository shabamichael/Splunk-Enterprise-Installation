#!/bin/bash

###############################################
#Function to read out of the configuraion files
###############################################
getConfig() {
    CONFIG="$1"
    grep -i ${CONFIG} ./config.cfg | sed 's/'"${CONFIG}"'=\([[:alnum:][:punct:]]\+\)/\1/'
}
#*********************************************************************************************

#==============================================================================================
# --- Configuration Parameters---
export SPLUNK_VERSION=$(getConfig splunk_version)
export SPLUNK_BUILD=$(getConfig splunk_build)
export SPLUNK_INSTALL_DIR=$(getConfig splunk_install_dir)
export SPLUNK_DOWNLOAD_URL=$(getConfig splunk_download_url)

# Splunk user and password
export SPLUNK_USER=$(getConfig splunk_user)
export SPLUNK_PASSWORD=$(getConfig splunk_password) # <-- Change this to a secure password
#==============================================================================================

#+++++++++++++++++++++++++++++++++++++
#Function to install splunk enterprise
#+++++++++++++++++++++++++++++++++++++
installSplunk() {
echo "====SPLUNK INSTALLATION==="

createInstallationDirectory
createSplunkUserAccount
downloadPackage
extractDownload
}
#*********************************************************************************************


#++++++++++++++++++++++++++++++++++++++++
# Function to Download the Splunk package
#++++++++++++++++++++++++++++++++++++++++
downloadPackage(){
echo "3. Downloading Splunk Enterprise ${SPLUNK_VERSION}... from"
echo
sudo wget -O ${SPLUNK_DOWNLOAD_URL}

# Check if the download was successful
if [ $? -ne 0 ]; then
echo "Failed to download Splunk Enterprise. Please check the URL or your internet connection."
exit 1
else
echo "Download completed successfully."
fi
}
#*********************************************************************************************

#+++++++++++++++++++++++++++++++++++++++++++++++
#Function that creates the installation directory
#+++++++++++++++++++++++++++++++++++++++++++++++
createInstallationDirectory(){
#1. Check if the installation directory exists
echo "1. Creating directory where Splunk would be installed $SPLUNK_INSTALL_DIR"
if [ ! -d "$SPLUNK_INSTALL_DIR" ]; then
  sudo mkdir -p ${SPLUNK_INSTALL_DIR}
fi
echo "   The directory where Splunk would be installed exist at ${SPLUNK_INSTALL_DIR}"
}
#*********************************************************************************************

#+++++++++++++++++++++++++++++++
# Extract the downloaded package
#+++++++++++++++++++++++++++++++
extractDownload(){
echo
echo "4. Installing the tar file in the ${SPLUNK_INSTALL_DIR}"
tar -xvzf splunk-${SPLUNK_VERSION}-${SPLUNK_BUILD}-linux-amd64.tgz -C ${SPLUNK_INSTALL_DIR} --strip-components=1
echo "   splunk-${SPLUNK_VERSION}-${SPLUNK_BUILD}-linux-amd64.tgz -C ${SPLUNK_INSTALL_DIR}"
echo "   Successfully installed or untar the Splunk SPLUNK_BUILDfile"

# Enable Splunk to start at boot
echo "   Enable Splunk to start at boot"
sudo ${SPLUNK_INSTALL_DIR}"/bin/splunk" enable boot-start -user ${SPLUNK_USER} -systemd-managed 1

# Stop Splunk after setup
echo "   Stop Splunk after setup"
sudo -u ${SPLUNK_USER} ${SPLUNK_INSTALL_DIR}"/bin/splunk" stop
}
#*********************************************************************************************

#+++++++++++++++++++++++++++++++++++++++
# Create splunk user if it doesn't exist
#+++++++++++++++++++++++++++++++++++++++
createSplunkUserAccount(){
echo
echo "2. Create a ${SPLUNK_USER} user account if it doesn't exist"
if ! id ${SPLUNK_USER} &>/dev/null; then
        echo
        echo "${SPLUNK_USER} user account does not exists"
        echo "   Creating user ${SPLUNK_USER}..."
        sudo useradd -m ${SPLUNK_USER}
        echo "   ${SPLUNK_USER} user account created."
        echo

else
        echo "   ${SPLUNK_USER} user account already exists"
        echo
fi

# Set password for splunk user
echo "   Set the password for splunk user"
echo    ${SPLUNK_USER}:${SPLUNK_PASSWORD} | sudo chpasswd

# Set permissions
echo "   Changing the permission for ${SPLUNK_INSTALL_DIR} to ${SPLUNK_USER} user account to"
sudo chown -R ${SPLUNK_USER}:${SPLUNK_USER} ${SPLUNK_INSTALL_DIR}
}
#*********************************************************************************************



echo
echo "...Installing Splunk Enterprise ..."
echo

installSplunk

echo
echo "...Splunk enterprise successfully installed!!!..."
echo
