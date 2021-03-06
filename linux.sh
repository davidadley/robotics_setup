#!/bin/bash

# This script is intended to setup a fresh desktop with ROS and
# with dependencies on homebrew or linuxbrew depending on the OS being used
# @author Andrew Hundt <ATHundt@gmail.com>
#
# 
# One step setup command for robonetracker:
# bash <(curl -fsSL https://raw.githubusercontent.com/ahundt/homebrew-robotics/master/robonetracker.sh)

echo ""
echo "###############################################################################################"
echo "# Make sure you have access to https://github.com/ahundt/robonetracker                        #"
echo "# Also, ensure you have your ssh key configured, if you don't you'll have to finish manually! #"
echo "###############################################################################################"
echo ""
# partly based on https://github.com/ahundt/homebrew-robotics/blob/master/robonetracker.sh

# source: https://gist.github.com/phatblat/1713458
# Save script's current directory
DIR=$(pwd)

# /bin/bash
set -e
set -u
set -x


sudo apt -y update
# minimal linuxbrew requirements
sudo apt install -y build-essential curl git python-setuptools ruby

# additional useful tools that should probably be owned by the OS rather than linuxbrew
sudo apt install -y screen tree sudo ssh x11-apps synaptic build-essential git

sudo apt install -y linux-headers-$(uname -r)

cd ~

if [ ! -d `pwd`/src ] ; then
    mkdir src;
fi

cd src


# USB wireless adapter driver 
# TP-Link Archer T4U dual band 802.11 ac
# http://askubuntu.com/questions/533408/trying-to-install-wireless-archer-t4u-driver
wireless_pkg=false

if [ $wireless_pkg ] ; then

	# package based USB wireless adapter install instructions
	sudo apt install rtl8812au-dkms

else
        # compile wireless driver from source
	if [ ! -d `pwd`/rtl8812AU_8821AU_linux ] ; then
	  git clone https://github.com/abperiasamy/rtl8812AU_8821AU_linux.git
	fi

	cd rtl8812AU_8821AU_linux/
	git pull
	make
	sudo make install
	sudo modprobe 8812au
fi




cd $DIR
