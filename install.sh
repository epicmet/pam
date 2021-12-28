#! /bin/bash

echo "Getting source code from repo..."
wget -q -O - https://raw.githubusercontent.com/MahdiAghaei1/pam/master/pam.sh > temp.sh

if [ $? -ne 0 ]
then
    echo "Error while downloading the source code. Make sure that you have wget installed and your network connection is stable."
    exit 1
fi

echo "Making pam executable..."
sudo cp temp.sh /usr/local/bin/pam &&
sudo chmod +rx /usr/local/bin/pam &&
rm temp.sh

echo "pam is now installed. enjoy"
pam --help