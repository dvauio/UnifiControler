#!/bin/bash

# Add MongoDB List Key
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6

# MongoDB List File
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list

# Unifi List Key
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 06E85760C0A52C50

# Unifi List File
echo 'deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list

# Add certbot repository
sudo add-apt-repository ppa:certbot/certbot -y

# Update Package Lists
sudo apt update

# Install MongoDB 3.4
sudo apt-get install mongodb-org -y

# Install Unifi
sudo apt-get install unifi -y

# Install Certbot
sudo apt install certbot -y

# Install haveged
sudo apt install haveged -y

# Create SWAP file
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo /swapfile none swap sw 0 0 | tee -a /etc/fstab
sudo echo 10 | sudo tee /proc/sys/vm/swappiness
sudo echo vm.swappiness = 10 | sudo tee -a /etc/sysctl.conf
sudo sysctl vm.vfs_cache_pressure=50

# Request SSL cert
sudo certbot certonly --standalone -d unifisvr6.ripstone.co.uk --register-unsafely-without-email --non-interactive --agree-tos

#Import Cert
cd /etc/letsencrypt/live/unifisvr6.ripstone.co.uk/
openssl pkcs12 -export -in cert.pem -inkey privkey.pem -out unifi.p12 -name unifi -CAfile fullchain.pem -caname root
mv /var/lib/unifi/keystore /var/lib/unifi/keystore.backup
cd /etc/letsencrypt/live/unifisvr6.ripstone.co.uk
keytool -importkeystore -deststorepass aircontrolenterprise -destkeypass aircontrolenterprise -destkeystore /var/lib/unifi/keystore -srckeystore unifi.p12 -srcstoretype PKCS12 -alias unifi

#Restart Unifi service
service unifi restart

# Update OS
sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade 
