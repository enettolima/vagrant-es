#!/usr/bin/env bash

#accommodate proxy environments
#export http_proxy=http://proxy.company.com:8080
#export https_proxy=https://proxy.company.com:8080
#Setting colors
RED='\033[0;31m'
NC='\033[0m' # No Color
#Creating required folder(s)
printf "${NC}Creating directory\n"
mkdir -p /var/www
#Updating Apt
printf "${NC}Updating Ubuntu\n"
sudo add-apt-repository ppa:webupd8team/java
apt-get -y update
#INstalling java
printf "${NC}Installing java\n"
sudo apt-get -y install default-jre
sudo apt-get -y install default-jdk
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
#install curl so we can test call on the command line\
printf "${NC}Installing Elastic Search v2.2\n"
sudo apt-get -y install curl


#To Run ES with debian package
cd /var/www
sudo dpkg -i elasticsearch-2.2.0.deb

sleep 3

printf "${NC}Installing Marvel Plugin\n"
sudo chmod -R 777 /etc/elasticsearch
cp /var/www/elasticsearch-2.2.0/config/elasticsearch.yml /etc/elasticsearch

sudo chmod -R 777 /usr/share/elasticsearch
cd /usr/share/elasticsearch
./bin/plugin install license

./bin/plugin install marvel-agent

printf "${NC}Installing Kibana4.4.0\n"
cd /etc/elasticsearch
mkdir kibana
cp -r /var/www/kibana-4.4.0-linux-x64/* kibana/
cd kibana

bin/kibana plugin --install elasticsearch/marvel/latest

sudo service elasticsearch restart

printf "${NC}Running ElasticSearch\n"
sudo service elasticsearch restart

ifconfig
printf "${NC} Log directory -> /var/log/elasticsearch\n"
printf "${NC} Data directory -> /var/lib/elasticsearch\n"
printf "${NC} Configuration directory -> /etc/elasticsearch\n"
printf "${NC} Binary directory -> /usr/share/elasticsearch\n"


printf "${NC} Edit the file /etc/elasticsearch/kibana/config/kibana.yml and change it to have your ip address as:\n\n\n"
printf "${NC} # Kibana is served by a back end server. This controls which port to use.\n
# server.port: 5601\n

# The host to bind the server to.\n
server.host: \"192.168.3.110\"\n

# If you are running kibana behind a proxy, and want to mount it at a path,\n
# specify that path here. The basePath can't end in a slash.\n
# server.basePath: \"\"\n

# The maximum payload size in bytes on incoming server requests.\n
# server.maxPayloadBytes: 1048576\n

# The Elasticsearch instance to use for all your queries.\n
elasticsearch.url: \"http://192.168.3.110:9200\" \n"
printf "${NC} \n\n\nAlso change the /etc/elasticsearch/elasticsearch.yml and add your ip like:\n
# Set the bind address to a specific IP (IPv4 or IPv6):\n
#\n
network.host: 192.168.3.110 \n\n"
printf "${NC} After that restart both services\n
sudo service elasticsearch restart\n
cd /etc/elasticsearch/kibana\n
bin/kibana"


# printf "${NC}Running ElasticSearch\n"
# #To Run ES on command line
# #copy elasticsearch to a specific dir inside the system
# sudo mkdir /etc/elastic
# sudo cp -r /var/www/elasticsearch-2.2.0 /etc/elastic/
# #change permissions
# sudo chmod -R 777 /etc/elastic
# #go to the folder where elastic search is
# cd /etc/elastic/elasticsearch-2.2.0/bin
# #Start Elastic Search
# ./elasticsearch
# sleep 12
# #make a call to make sure its installed
# curl -XGET localhost:9200/_cluster/health?pretty
#
# printf "${NC} To run Elastic search go to /etc/elastic/elasticsearch-2.2.0/bin and do ./elasticsearch"
