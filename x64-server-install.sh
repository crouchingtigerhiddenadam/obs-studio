mkdir .sources
cd .sources

sudo apt update
sudo apt -y install\
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
 pkg-config\
 python3-dev\
 qtbase5-dev\
 swig\
 wget\
 xcb

wget -O cef.tar.bz2 http://opensource.spotify.com/cefbuilds/cef_binary_86.0.14%2Bg0b3aeae%2Bchromium-86.0.4240.75_linux64.tar.bz2
tar -xvjf cef.tar.bz2
rm cef.tar.bz2
mv cef_binary_86.0.14+g0b3aeae+chromium-86.0.4240.75_linux64 cef
rm cef.tar.bz2

wget -O nodejs.tar.gz https://nodejs.org/dist/v12.19.0/node-v12.19.0.tar.gz
tar -xvf nodejs.tar.gz
rm nodejs.tar.gz
mv node-v12.19.0 nodejs
cd nodejs
./configure
make
sudo make install
cd ../

git clone --recursive https://github.com/obsproject/obs-studio.git obs-studio
mkdir obs-studio/build
cd ./obs-studio/build
cmake -DBUILD_BROWSER="ON" -DCEF_ROOT_DIR="../../cef" -DCMAKE_INSTALL_PREFIX="/usr" -DUNIX_STRUCTURE="1" ..
cmake -DCMAKE_INSTALL_PREFIX="/usr" -DUNIX_STRUCTURE="1" ..
make
sudo make install
cd ../../

git clone --recursive https://github.com/Palakis/obs-websocket.git obs-websocket
mkdir ./obs-websocket/build
cd ./obs-websocket/build
cmake -DLIBOBS_INCLUDE_DIR="../obs-studio/UI" -DCMAKE_INSTALL_PREFIX=/usr -DUSE_UBUNTU_FIX=true ..
make
make install
cd ../../

git clone https://github.com/t2t2/obs-tablet-remote obs-tabletremote
cd ./obs-tabletremote/
npm install
npm run build
cd ../
