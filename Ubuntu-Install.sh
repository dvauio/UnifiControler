# Notes
wget -O - https://raw.githubusercontent.com/dvauio/WiFi/master/Unifi-Server-Installer.sh | bash
#

echo Update OS
sudo dpkg --configure -a
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y

# Create SWAP file
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo /swapfile none swap sw 0 0 | tee -a /etc/fstab
sudo echo 10 | sudo tee /proc/sys/vm/swappiness
sudo echo vm.swappiness = 10 | sudo tee -a /etc/sysctl.conf
sudo sysctl vm.vfs_cache_pressure=50

# Install Certbot
sudo add-apt-repository ppa:certbot/certbot -y
sudo apt update
sudo apt install certbot -y

# Install haveged
sudo apt install haveged -y

# Update package list & install updates
sudo apt update && sudo apt upgrade -y

# Add MongoDB List Key
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6

# MongoDB List File
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list

# Unifi List Key
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 06E85760C0A52C50

# Unifi List File
echo 'deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list

# Update package database
sudo apt-get update

# Install MongoDB 3.4
sudo apt-get install mongodb-org

# Install Unifi
sudo apt-get install unifi
