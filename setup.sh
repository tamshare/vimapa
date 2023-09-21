#!/bin/bash

# Set your desired username and password
username="hearhour"
password="Hour010888461"

# Update package lists
sudo apt update

# Install Squid proxy server
sudo apt install -y squid

# Install Apache2 utilities
sudo apt install -y apache2-utils

# Generate the password hash
password_hash=$(sudo htpasswd -nbB "$username" "$password")

# Add the password hash to the password file
echo "$password_hash" | sudo tee -a /etc/squid/passwd >/dev/null

# Set permissions on the password file
sudo chown proxy:proxy /etc/squid/passwd
sudo chmod 600 /etc/squid/passwd

# Modify the Squid configuration file to include auth_param and additional settings
sudo sed -i 's/# And finally deny all other access to this proxy/\
# Add basic authentication parameters\n\
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd\n\
auth_param basic children 5\n\
auth_param basic realm Squid proxy-caching web server\n\
acl authenticated proxy_auth REQUIRED\n\
http_access allow authenticated\n\
\n\
# And finally deny all other access to this proxy/' /etc/squid/squid.conf

sudo sed -i 's/http_access deny all/http_access allow all/' /etc/squid/squid.conf
sudo sed -i 's/http_port 3128/http_port 8884/' /etc/squid/squid.conf

# Restart Squid to apply the configuration changes
sudo service squid restart
