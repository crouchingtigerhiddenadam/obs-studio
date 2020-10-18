##########################################################################
# Debian OBS Studio Server Install Script                                #
##########################################################################

mkdir /opt/.sources
cd /opt/.sources

# Setup APT
echo "deb http://mirror.ox.ac.uk/debian/ buster main contrib non-free" | tee /etc/apt/sources.list
echo "deb-src http://mirror.ox.ac.uk/debian/ buster main contrib non-free" | tee -a /etc/apt/sources.list
echo "" | tee -a /etc/apt/sources.list
echo "deb http://security.debian.org/debian-security buster/updates main contrib non-free" | tee -a /etc/apt/sources.list
echo "deb-src http://security.debian.org/debian-security buster/updates main contrib non-free" | tee -a /etc/apt/sources.list
echo "" | tee -a /etc/apt/sources.list
echo "deb http://mirror.ox.ac.uk/debian/ buster-updates main contrib non-free" | tee -a /etc/apt/sources.list
echo "deb-src http://mirror.ox.ac.uk/debian/ buster-updates main contrib non-free" | tee -a /etc/apt/sources.list
echo "" | tee -a /etc/apt/sources.list
echo "deb http://deb.debian.org/debian buster-backports main contrib non-free" | tee -a /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian buster-backports main contrib non-free" | tee -a /etc/apt/sources.list
apt update

# Setup Build Essentials
apt -y install\
 build-essential\
 checkinstall\
 cmake\
 git\
 libasound2-dev\
 libavcodec-dev\
 libavdevice-dev\
 libavfilter-dev\
 libavformat-dev\
 libavutil-dev\
 libboost-all-dev\
 libfdk-aac-dev\
 libcurl4-openssl-dev\
 libfontconfig1-dev\
 libfreetype6-dev\
 libgl1-mesa-dev\
 libjack-jackd2-dev\
 libjansson-dev\
 libluajit-5.1-dev\
 libmbedtls-dev\
 libnss3-dev\
 libpulse-dev\
 libqt5svg5-dev\
 libqt5x11extras5-dev\
 libspeexdsp-dev\
 libswresample-dev\
 libswscale-dev\
 libudev-dev\
 libv4l-dev\
 libvlc-dev\
 libx11-dev\
 libx11-xcb1\
 libx11-xcb-dev\
 libx264-dev\
 libxcb-randr0-dev\
 libxcb-shm0-dev\
 libxcb-xfixes0-dev\
 libxcb-xinerama0-dev\
 libxcb-xinput0\
 libxcb-xinput-dev\
 libxcomposite-dev\
 libxinerama-dev\
 libxss-dev\
 pkg-config\
 python3-dev\
 qtbase5-dev\
 swig\
 wget\
 xcb

# Chrome Embedded Framework
wget -O cef.tar.bz2 https://cdn-fastly.obsproject.com/downloads/cef_binary_3770_linux64.tar.bz2
tar -xvjf ./cef.tar.bz2
mv ./cef_binary_3770_linux64 ./cef

# OBS Studio
git clone --recursive https://github.com/obsproject/obs-studio.git obs-studio
mkdir ./obs-studio/build
cd ./obs-studio/build
cmake -DBUILD_BROWSER=ON -DCEF_ROOT_DIR="../../cef" -DCMAKE_INSTALL_PREFIX=/usr -DUNIX_STRUCTURE=1 ..
make
make install
cd ../..

# OBS Websocket
git clone --recursive https://github.com/Palakis/obs-websocket.git obs-websocket
mkdir ./obs-websocket/build
cd ./obs-websocket/build
cmake -DLIBOBS_INCLUDE_DIR="../obs-studio/UI" -DCMAKE_INSTALL_PREFIX=/usr -DUSE_UBUNTU_FIX=true ..
make
make install
cd ../..

# NodeJS
apt -y install\
 npm\
 nodejs
# wget -O nodejs.tar.gz https://nodejs.org/dist/v12.19.0/node-v12.19.0.tar.gz
# tar -xvf nodejs.tar.gz
# mv ./node-v12.19.0 ./nodejs
# cd ./nodejs
# ./configure
# make
# make install
# cd ..

# OBS Tablet Remote
git clone https://github.com/t2t2/obs-tablet-remote obs-tabletremote
cd ./obs-tabletremote/
npm install
npm run build

# Install User Interface
apt -y install chromium\
 lxde-core\

# Install VNC
apt -y install x11vnc
echo "[Unit]" | tee /lib/systemd/system/x11vnc.service
echo "Description=x11vnc server" | tee -a /lib/systemd/system/x11vnc.service
echo "After=syslog.target network.target" | tee -a /lib/systemd/system/x11vnc.service
echo "" | tee -a /lib/systemd/system/x11vnc.service
echo "[Service]" | tee -a /lib/systemd/system/x11vnc.service
echo "ExecStart=/usr/bin/x11vnc -create -xkb -noxrecord -noxfixes -noxdamage -display :0 -auth /var/run/lightdm/root/:0 -rfbport 5901" | tee -a /lib/systemd/system/x11vnc.service
echo "" | tee -a /lib/systemd/system/x11vnc.service
echo "[Install]" | tee -a /lib/systemd/system/x11vnc.service
echo "WantedBy=multi-user.target" | tee -a /lib/systemd/system/x11vnc.service
systemctl daemon-reload
systemctl enable x11vnc

# Install NGINX
apt -y install nginx
cp -r /opt/.sources/obs-tabletremote/dist/* /var/www/html/
