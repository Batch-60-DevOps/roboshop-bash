#!/bin/bash

# I want to make sure that the scirpt has to validate whether the user running the script is root user or not, if not root user, script has to be exited
COMPONENT="catalogue"
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

echo "desabling the default nodejs repo"
dnf module disable nodejs -y &>> $LOG
stat $?
echo "enabling the nodejs 20 version"
dnf module enable nodejs:20 -y &>> $LOG
stat $?

echo "installing nodejs"
dnf install nodejs -y &>> $LOG
stat $?

echo "creating roboshop user"
useradd $APPUSER &>> $LOG
stat $?

echo "performing clean up and creating app directory"
rm -rf /app/* &>> $LOG
mkdir /app &>> $LOG
stat $?

echo "downloading the $COMPONENT app"
curl -L -o /tmp/${COMPONENT}.zip https://stan-robotshop.s3.amazonaws.com/${COMPONENT}-v3.zip &>> $LOG
stat $? 

echo "extracting the $COMPONENT app"
unzip -o /tmp/${COMPONENT}.zip -d /app/ &>> $LOG
stat $? 

echo "generating $COMPONENT artifact"
npm install --prefix /app/ &>> $LOG
stat $?

echo -n "Configuring $COMPONENT systemd file :"
cp ${COMPONENT}.service /etc/systemd/system/${COMPONENT}.service
stat $?
echo -n "Starting $COMPONENT service :"

echo "installing mongodb shell repo"
cp mongo.repo /etc/yum.repos.d/mongodb.repo &>> $LOG
stat $?
echo "installing mongodb shell"
dnf install mongodb-mongosh -y &>> $LOG
stat $?
echo "injecting the schema for $COMPONENT"
mongosh --host mongodb.footballo.space  < /app/db/master-data.js &>> $LOG
stat $?

echo "starting $COMPONENT service"
systemctl enable $COMPONENT &>> $LOG
systemctl start $COMPONENT &>> $LOG
stat $? 
echo -e "\e[32m $COMPONENT setup is completed \e[0m"

