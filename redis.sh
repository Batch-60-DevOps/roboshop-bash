#!/bin/bash

# I want to make sure that the scirpt has to validate whether the user running the script is root user or not, if not root user, script has to be exited
COMPONENT="redis"
ID=$(id -u)
LOG="/tmp/${COMPONENT}.log"
APPUSER="roboshop"
#source ./common.sh
echo "configuration management for $COMPONENT in progress"

if [ $ID -ne 0 ]; then
echo -e "\e[31m you should run this script as root or with sudo privileage \e[0m]"
echo -e "Example: Usage: \e[36msudo bash $0 \e[0m"
exit 1
fi

stat() {
    if [ $1 -eq 0 ] ;then
        echo -e "\e[32m SUCCESS \e[0m"
    else
        echo -e "\e[31m FAILURE \e[0m"
        exit 1
    fi
}

echo "desabling the default redis repo"
dnf module disable redis -y &>> $LOG
stat $?
echo "enabling the redis 7 version"
dnf module enable redis:7 -y &>> $LOG
stat $?

echo "installing redis"
dnf install redis -y &>> $LOG
stat $?

echo "updating the redis config file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf &>> $LOG
stat $?

echo "protecting mode is no"
sed -i -e 's/protected-mode yes/protected-mode no/g' /etc/redis/redis.conf &>> $LOG
stat $?

echo "starting $COMPONENT service"
systemctl enable $COMPONENT &>> $LOG
systemctl start $COMPONENT &>> $LOG
stat $? 
echo -e "\e[32m $COMPONENT setup is completed \e[0m"