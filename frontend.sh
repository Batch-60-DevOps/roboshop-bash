#!/bin/bash
echo "enable the frontend repo"
echo "disabling the default nginx repo"
dnf module disable nginx -y

echo "enable the nginx 24 version"
dnf module enable nginx:1.24 -y

echo "installing nginx"
dnf install ngnix -y
