#!/bin/bash
echo "configuration managment of  the frontend application"

ID=$(id -u)
if [ $ID -ne 0 ]; then
echo -e "\e[31m you should run this script as root or with sudo privileage \e[0m]"
echo -e "Example: Usage: \e[36msudo bash $0 \e[0m]"
exit 1
fi
echo "running with user ID: $ID"

echo "disabling the default nginx repo"
dnf module disable nginx -y

echo "enable the nginx 24 version"
dnf module enable nginx:1.24 -y

echo "installing nginx"
dnf install ngnix -y
