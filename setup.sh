
# Set your desired username
username="hearhour"

# Set your desired password
password="Hour010888461"

# Update package lists
sudo apt update

# Install Squid proxy server
sudo apt install -y squid

# Install Apache2 utilities
sudo apt install -y apache2-utils


sudo sed -i '1i http_access allow authenticated' /etc/squid/squid.conf
sudo sed -i '1i acl authenticated proxy_auth REQUIRED' /etc/squid/squid.conf
sudo sed -i '1i auth_param basic realm Squid proxy-caching web server' /etc/squid/squid.conf
sudo sed -i '1i auth_param basic children 5' /etc/squid/squid.conf
sudo sed -i '1i auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd' /etc/squid/squid.conf

sudo sed -i 's/http_access deny all/http_access allow all/' /etc/squid/squid.conf
sudo sed -i 's/http_port 3128/http_port 8884/' /etc/squid/squid.conf

sudo ufw allow 8884



echo "$password" | sudo htpasswd -c /etc/squid/passwd "$username"

# Set permissions on the password file
sudo chown proxy:proxy /etc/squid/passwd
sudo chmod 600 /etc/squid/passwd
