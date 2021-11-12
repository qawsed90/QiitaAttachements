#!/bin/sh
rm -rf ./debwork

#memo: change from original .config
#CONFIG_IKHEADERS=m
#CONFIG_NET_SCH_SFQ=m
#CONFIG_NET_ACT_POLICE=m
#CONFIG_NET_ACT_GACT=m

cd ../zfs-2.1.1_build/module
make -j12 DESTDIR=$(pwd)/../../WSL2-Linux-Kernel/debwork 
make -j12 DESTDIR=$(pwd)/../../WSL2-Linux-Kernel/debwork install
cd ../../WSL2-Linux-Kernel
make -j12 INSTALL_MOD_PATH=$(pwd)/debwork LOCALVERSION= modules
make -j12 INSTALL_MOD_PATH=$(pwd)/debwork LOCALVERSION= modules_install

KERNELVER=$(uname -r)
VERSION=$(echo ${KERNELVER}|awk -F'[-]' '{print $1}')
RELEASE="2"
INSTALLED_SIZE=$(du -ks debwork|awk '{print $1}')

mkdir -p ./debwork/DEBIAN
cat > debwork/DEBIAN/control << EOF
Package: linux-module-${KERNELVER}
Priority: extra
Section: kernel
Installed-Size: ${INSTALLED_SIZE}
Maintainer: $(whoami)@$(hostname)
Architecture: amd64
Version: ${VERSION}-${RELEASE}
Provides: linux-module
Description: module files for WSL linux kernel
EOF

cat > debwork/DEBIAN/postinst << EOF
#!/bin/sh
depmod ${KERNELVER}
EOF
chmod 755 debwork/DEBIAN/postinst 

fakeroot dpkg-deb --build debwork .

