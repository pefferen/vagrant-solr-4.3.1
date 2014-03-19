# Vagrant box for Apache Solr 4.3.1 served by Apache Tomcat 6

## description

Vagrant box for Apache Solr 4.3.1 served by Apache Tomcat 6 on Ubuntu precise 32 bit.

## installation

1. Make shure you have Vagrant installed.
2. checkout the repo
3. cd to the directory and perform `vagrant up`
4. login to the admin to verify the installation by going to http://192.168.33.10:8080/solr/core0/admin/

## usage

After settin up the Vagrant box with the provisioning script, you can add cores like you are used to with Apache Solr.

1. add your core to /usr/share/solr/triquanta/multicore/ or copy one of the default cores,
2. add your core the the solr.xml file in that directory
3. restart Apache Tomcat `sudo service tomcat6 restart`

You will find the loggin files in /var/logs/tomcat/ .
