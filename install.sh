#!/bin/bash
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
printf '\033[8;25;105t'
echo "+---------------------------------------------!WARNING!---------------------------------------------+"
echo "| This script allows you to modify the maximum output power limitations set by the CRDA for         |"
echo "| wireless 802.11 devices.                                                                          |"
echo "|                                                                                                   |"
echo "| These limitations are set by national and international agencies. Changing These limitations      |"
echo "| outside of the maximum values already defined is illegal in most countries.                       |"
echo "|                                                                                                   |"
echo "| In addition to legality, higher power levels are harmful to health and can cause hardware failure.|"
echo "|                                                                                                   |"
echo "| Use this tool/script at your own risk.                                                            |"
echo "+---------------------------------------------------------------------------------------------------+"
echo ""
read -p "Are you sure you want to continue?" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	echo ""
    exit 1
fi
clear
echo "Updating system."
apt-get update 2>&1 >/dev/null
apt-get upgrade -y 2>&1 >/dev/null
echo "Create working directory."
mkdir -p /wifi-power/ 2>&1 >/dev/null
cd /wifi-power/ 2>&1 >/dev/null
echo "Downloading componets."
curl -s https://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2013.11.27.tar.bz2 -O 2>&1 >/dev/null
if [ ! -f wireless-regdb-2013.11.27.tar.bz2 ]; then
	echo "Download of wireless-regdb-2013.11.27.tar.bz2 failed."
	exit 1
fi
echo "Download of wireless-regdb-2013.11.27.tar.bz2 complete."
curl -s http://pkgs.fedoraproject.org/repo/pkgs/libnl3/libnl-3.2.26.tar.gz/c8de31b74b1c15267b5ac2927b11125c/libnl-3.2.26.tar.gz -O 2>&1 >/dev/null
if [ ! -f libnl-3.2.26.tar.gz ]; then
	echo "Download of libnl-3.2.26.tar.gz failed."
	exit 1
fi
echo "Download of libnl-3.2.26.tar.gz complete."
curl -s http://gnu.mirror.iweb.com/bison/bison-3.0.4.tar.gz -O 2>&1 >/dev/null
if [ ! -f bison-3.0.4.tar.gz ]; then
	echo "Download of bison-3.0.4.tar.gz failed."
	exit 1
fi
echo "Download of bison-3.0.4.tar.gz complete."
curl -s ftp://ftp.dk.netbsd.org/.m/mirrors1e/ftp.kernel.org/pub/software/network/crda/crda-1.1.3.tar.bz2 -O 2>&1 >/dev/null
if [ ! -f crda-1.1.3.tar.bz2 ]; then
	echo "Download of crda-1.1.3.tar.bz2 failed."
	exit 1
fi
echo "Download of crda-1.1.3.tar.bz2 complete."
curl -s https://launchpadlibrarian.net/201289896/libgcrypt11_1.5.3-2ubuntu4.2_amd64.deb -O 2>&1 >/dev/null
if [ ! -f libgcrypt11_1.5.3-2ubuntu4.2_amd64.deb ]; then
	echo "Download of libgcrypt11_1.5.3-2ubuntu4.2_amd64.deb failed."
	exit 1
fi
echo "Download of libgcrypt11_1.5.3-2ubuntu4.2_amd64.deb complete."
echo "Extracting componets and cleaning up."
tar -xvf wireless-regdb-2013.11.27.tar.bz2 2>&1 >/dev/null
tar -xvf libnl-3.2.26.tar.gz 2>&1 >/dev/null
tar -xvf bison-3.0.4.tar.gz 2>&1 >/dev/null
tar -xvf crda-1.1.3.tar.bz2 2>&1 >/dev/null
rm wireless-regdb-2013.11.27.tar.bz2 2>&1 >/dev/null
rm libnl-3.2.26.tar.gz 2>&1 >/dev/null
rm bison-3.0.4.tar.gz 2>&1 >/dev/null
rm crda-1.1.3.tar.bz2 2>&1 >/dev/null
echo "Installing libgcrypt11.1.3.5"
dpkg -i libgcrypt11_1.5.3-2ubuntu4.2_amd64.deb 2>&1 >/dev/null
rm libgcrypt11_1.5.3-2ubuntu4.2_amd64.deb 2>&1 >/dev/null
apt-get update 2>&1 >/dev/null
sudo apt-get install libgcrypt11-dev -y 2>&1 >/dev/null
echo "Installing bison 3.0.4"
cd /wifi-power/bison-3.0.4 2>&1 >/dev/null
./configure > /dev/null 2>&1
make > /dev/null 2>&1
make install > /dev/null 2>&1
echo "Installing libnl3.2.6"
cd /wifi-power/libnl-3.2.26 2>&1 >/dev/null
./configure > /dev/null 2>&1
make > /dev/null 2>&1
make install > /dev/null 2>&1
cd /wifi-power/wireless-regdb-2013.11.27 2>&1 >/dev/null
echo ""
echo "Reference below table for dBm values."
echo "+-dBm-----mW--+"
echo "| 20  | 100 mW|"
echo "| 21  | 126 mW|"
echo "| 22  | 158 mW|"
echo "| 23  | 200 mW|"
echo "| 24  | 250 mW|"
echo "| 25  | 316 mW|"
echo "| 26  | 398 mW|"
echo "| 27  | 500 mW|"
echo "| 28  | 630 mW|"
echo "| 29  | 800 mW|"
echo "| 30  | 1.0 W |"
echo "| 31  | 1.3 W |"
echo "| 32  | 1.6 W |"
echo "| 33  | 2.0 W |"
echo "| 34  | 2.5 W |"
echo "| 35  | 3.2 W |"
echo "+-------------+"
echo ""
echo "To remain legal simply close VIM with :q otherwise edit lines 3, 4, 7, 9, 12."
read -p "Press enter to edit with VIM."
gnome-terminal -e "vim db.txt"
echo ""
#echo "To remain legal simply close VIM with :q otherwise edit lines 795-798."
#read -p "Press enter to edit with VIM."
#gnome-terminal -e "vim +795 db.txt"
#echo ""
read -p "Press enter to finish building."
echo "Compiling database."
make > /dev/null 2>&1
echo "Making new CRDA directory."
mkdir /usr/lib/crda/ > /dev/null 2>&1
echo "Copying databse."
cp regulatory.bin /usr/lib/crda/regulatory.bin 2>&1 >/dev/null
echo "Copying keys."
cp *.pem /wifi-power/crda-1.1.3/pubkeys/ 2>&1 >/dev/null
cp /lib/crda/pubkeys/*.pem /wifi-power/crda-1.1.3/pubkeys/ 2>&1 >/dev/null
echo "Installing CRDA 1.1.3"
cd /wifi-power/crda-1.1.3 2>&1 >/dev/null
make 2>&1 >/dev/null
make install 2>&1 >/dev/null
echo "Modified CRDA tables installed."