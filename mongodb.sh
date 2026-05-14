#!/bin/bash
echo "configuration managment of the mongodb application"
ID=$(id -u)
COMPONENT="mongodb"
LOG="/tmp/$COMPONENT.log"
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

echo "installing mongodb repo"
cp mongo.repo /etc/yum.repos.d/mongodb.repo &>> $LOG
stat $?

echo "installing mongodb"
dnf install mongodb-org -y &>> $LOG
stat $?

echo "updating the mongodb config file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOG
stat $?

echo "starting mongodb service"
systemctl enable mongod &>> $LOG
systemctl start mongod &>> $LOG
stat $?

echo -e "\e[32m mongodb setup is completed \e[0m"