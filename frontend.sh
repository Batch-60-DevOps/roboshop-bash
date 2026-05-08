#!/bin/bash
echo "configuration managment of the frontend application"
ID=$(id -u)
COMPONENT="frontend"
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

echo "disabling the default nginx repo"
dnf module disable nginx -y &>> /tmp/$COMPONENT.log
stat $?

echo "enable the nginx 24 version"
dnf module enable nginx:1.24 -y &>> /tmp/$COMPONENT.log
stat $?

echo "installing nginx"
dnf install nginx -y &>> /tmp/$COMPONENT.log  
stat $?

echo "downloading the frontend content"
curl -L -o /tmp/frontend.zip https://stan-robotshop.s3.amazonaws.com/$COMPONENT-v3.zip /tmp/$COMPONENT.log
stat $?

echo "removing the old content"
rm -rf /usr/share/nginx/html/* &>> /tmp/$COMPONENT.log

echo "extracting the downloaded content"
unzip /tmp/frontend.zip -d /usr/share/nginx/html/ &>> /tmp/$COMPONENT.log
stat $?

echo "starting nginx service"
systemctl enable nginx &>> /tmp/$COMPONENT.log
systemctl start nginx &>> /tmp/$COMPONENT.log
stat $?

echo -e "\e[32m frontend setup is completed \e[0m"