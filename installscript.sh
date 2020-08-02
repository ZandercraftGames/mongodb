#!/bin/bash
# MongoDB Installation Script
#
# Server Files: /mnt/server
set -x
echo -e "installing dependencies"
apt-get -y update
apt-get -y install curl
apt-get -y install tar
## add user
echo -e "adding container user"
useradd -d /home/container -m container -s /bin/bash
## own server to container user
chown container: /home/container
## run install script as user
echo -e "getting mongod.conf"
if [ -f /mnt/server/mongod.conf ]; then
echo -e "moving current config for install"
mv /mnt/server/mongod.conf /mnt/server/custom.mongod.conf
runuser -l container -c 'curl https://raw.githubusercontent.com/ZandercraftGames/mongodb/master/mongod.conf > /mnt/server/mongod.conf'
else
runuser -l container -c 'curl https://raw.githubusercontent.com/ZandercraftGames/mongodb/master/mongod.conf > /mnt/server/mongod.conf'
fi
## mkdir and install db
echo -e "installing mongoDB database"
runuser -l container -c 'mkdir -p /mnt/server/run/mongodb'
runuser -l container -c 'mkdir -p /mnt/server/log/mongodb'
runuser -l container -c 'mkdir /mnt/server/mongodb'
runuser -l container -c 'curl https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2004-4.4.0.tgz'
runuser -l container -c 'tar -xzvf mongodb-linux-x86_64-ubuntu2004-4.4.0.tgz -C /home/container'
runuser -l container -c 'export PATH=/mnt/server/bin:$PATH'
runuser -l container -c 'mkdir -p /mnt/server/data/db'
if [ -f /mnt/server/custom.mongod.conf ]; then
echo -e "moving current config back in place"
mv /mnt/server/custom.mongod.conf /mnt/server/mongod.conf
else
curl https://raw.githubusercontent.com/ZandercraftGames/mongodb/master/mongod.conf > /mnt/server/mongod.conf
fi
echo -e "install complete"
exit
