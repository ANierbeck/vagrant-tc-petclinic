#!/usr/bin/env bash

apt-get update
apt-get -y upgrade

echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get -y install oracle-java8-installer
#echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections

sudo apt-get -y install maven

sudo update-java-alternatives -s java-8-oracle

sudo apt-get -y install git

echo 'deb http://packages.elasticsearch.org/logstashforwarder/debian stable main' | sudo tee /etc/apt/sources.list.d/logstashforwarder.list

sudo apt-get -y update
sudo apt-get -y install logstash-forwarder

cd /etc/init.d/; sudo wget https://raw.github.com/elasticsearch/logstash-forwarder/master/logstash-forwarder.init -O logstash-forwarder
sudo chmod +x logstash-forwarder
sudo update-rc.d logstash-forwarder defaults
cd /home/vagrant 

sudo mkdir opt
cd opt
sudo wget http://apache.mirror.digionline.de/tomcat/tomcat-8/v8.0.12/bin/apache-tomcat-8.0.12.tar.gz
sudo tar xfvz apache-tomcat-8.0.12.tar.gz
cd ..
sudo chown -R vagrant:vagrant opt

git clone https://github.com/ANierbeck/spring-petclinic.git 
chown -R vagrant:vagrant spring-petclinic

su vagrant
cd spring-petclinic
mvn clean package

cd ..
cd opt
cd apache-tomcat-8.0.12
cp ../../spring-petclinic/target/petclinic.war ./webapps

bin/startup.sh

