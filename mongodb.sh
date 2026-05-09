#!/bin/bash
echo "configuration managment of the frontend application"
ID=$(id -u)
COMPONENT="mongodb"
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
cp mongodb.repo /etc/yum.repos.d/mongodb.repo &>> /tmp/$COMPONENT.log
stat $?

# dnf install mongodb-org -y 
# systemctl enable mongod
# systemctl start mongod

echo "installing mongodb"
dnf install mongodb-org -y &>> /tmp/$COMPONENT.log
stat $?


echo "starting mongodb service"
systemctl enable mongod &>> /tmp/$COMPONENT.log
systemctl start mongod &>> /tmp/$COMPONENT.log
stat $?

echo -e "\e[32m mongodb setup is completed \e[0m"