#! /bin/bash

echo "Getting source code from repo..."
wget -q -O - https://github.com/MahdiAghaei1/pam/releases/download/v0.0.1/pam.sh > temp.sh

echo "Making pam executable..."
cp temp.sh /usr/local/bin/pam &&
chmod +rx /usr/local/bin/pam &&
rm temp.sh

echo "pam is now installed. enjoy"
pam --help