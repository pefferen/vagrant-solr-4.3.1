#!/bin/bash

#        ___           ___           ___       ___
#       /\  \         /\  \         /\__\     /\  \
#      /::\  \       /::\  \       /:/  /    /::\  \
#     /:/\ \  \     /:/\:\  \     /:/  /    /:/\:\  \
#    _\:\~\ \  \   /:/  \:\  \   /:/  /    /::\~\:\  \
#   /\ \:\ \ \__\ /:/__/ \:\__\ /:/__/    /:/\:\ \:\__\
#   \:\ \:\ \/__/ \:\  \ /:/  / \:\  \    \/_|::\/:/  /
#    \:\ \:\__\    \:\  /:/  /   \:\  \      |:|::/  /
#     \:\/:/  /     \:\/:/  /     \:\  \     |:|\/__/
#      \::/  /       \::/  /       \:\__\    |:|  |
#       \/__/         \/__/         \/__/     \|__|
#
# Assumption we are using Ubuntu precise 32 bits (12.04)
# Apache Solr 3.4.1
# Vagrant provisioning script
# Author: Patrick van Efferen

# Variables.
# TODO: Create variables.

# First we update apt
echo "Updating apt"

sudo apt-get update
sudo apt-get upgrade

# Install tomcat
sudo apt-get install tomcat6 tomcat6-admin tomcat6-common tomcat6-user -y



# Download Solr 4.6.0 in the the directory and extract install
cd /tmp

# If Solr is not installed yet download it
if [ ! -f "/usr/share/tomcat6/webapps/solr4.war" ]; then
  # Download Solr
  wget http://archive.apache.org/dist/lucene/solr/4.3.1/solr-4.3.1.tgz
  tar xf solr-4.3.1.tgz
fi

# Check for solr base directory, if not create it.
if [ ! -d "/usr/share/solr4" ]; then
  # Create the Solr base directory/
  sudo mkdir /usr/share/solr4
fi

# Install Solr if it is not yet installed.
if [ ! -f "/usr/share/tomcat6/webapps/solr4.war" ]; then
  echo "Install Solr"
  # Copy the Solr webapp and the example multicore configuration files:
  sudo mkdir /usr/share/tomcat6/webapps
  sudo cp /tmp/solr-4.3.1/dist/solr-4.3.1.war /usr/share/tomcat6/webapps/solr4.war
  # sudo cp -R /tmp/solr-4.3.1/example/multicore/* /var/solr/

  # Copy other solr files to solr base directory.
  sudo cp -R /tmp/solr-4.3.1/* /usr/share/solr4/

  # Copy Log4J libraries.
  sudo cp /tmp/solr-4.3.1/example/lib/ext/* /usr/share/tomcat6/lib/
fi

# If not already done setup the core's.
if [ ! -d "/usr/share/solr4/triquanta" ]; then
  # Setup cores
  echo "seting up Solr cores"
  sudo mv /usr/share/solr4/example /usr/share/solr4/triquanta

  # Remove unnecesarry directories
  sudo rm -r /usr/share/solr4/triquanta/example-DIH
  sudo rm -r /usr/share/solr4/triquanta/exampledocs
  sudo rm -r /usr/share/solr4/triquanta/solr-webapp
fi


# Add configuration to settings file.
echo "Configuring Solr"
sudo echo "<Context docBase=\"/usr/share/tomcat6/webapps/solr4.war\" debug=\"0\" privileged=\"true\"
         allowLinking=\"true\" crossContext=\"true\">
    <Environment name=\"solr/home\" type=\"java.lang.String\"
                 value=\"/usr/share/solr4/triquanta/multicore\" override=\"true\" />
</Context>" > /etc/tomcat6/Catalina/localhost/solr.xml


# Set filepermissions
echo "Set filepermissions"
#sudo chown -R tomcat6 /usr/share/solr/
sudo chgrp -R tomcat6 /usr/share/solr4
sudo chmod -R 2750 /usr/share/solr4
sudo chmod -R 2770 /usr/share/solr4/triquanta/multicore/
sudo chmod -R o+x /usr/share/tomcat6/lib

# Setup Tomcat user.
echo "Setup Tomcat user."
sudo echo "<tomcat-users>
    <role rolename=\"admin\"/>
    <role rolename=\"manager\"/>
    <user username=\"triquanta\" password=\"aS2k4Ddf\" roles=\"admin,manager\"/>
</tomcat-users>" > /etc/tomcat6/tomcat-users.xml

# Restart Tomcat server
sudo service tomcat6 restart

echo "Ubuntu, Tomcat and Solr have been installed."
