#!/bin/sh
rm -rf ./debwork

make -j12 DESTDIR=$(pwd)/debwork 
make -j12 DESTDIR=$(pwd)/debwork install
rm -rf ./debwork/lib/modules/

VERSION="2.1.1"
RELEASE="2"
INSTALLED_SIZE=$(du -ks debwork|awk '{print $1}')

mkdir -p ./debwork/DEBIAN
cat > debwork/DEBIAN/control << EOF
Package: zfs
Priority: extra
Section: kernel
Installed-Size: ${INSTALLED_SIZE}
Maintainer: $(whoami)@$(hostname)
Architecture: amd64
Version: ${VERSION}-${RELEASE}
Provides: zfs
Description: zfs for WSL linux
EOF

fakeroot dpkg-deb --build debwork .

