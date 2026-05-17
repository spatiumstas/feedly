#!/bin/sh

found=0
opkg_repos=""

while read -r _ ARCH _; do
  if [ "$ARCH" = "aarch64-3.10" ] \
  || [ "$ARCH" = "armv7-3.2" ] \
  || [ "$ARCH" = "mips-3.4" ] \
  || [ "$ARCH" = "mipsel-3.4" ]; then
    echo "Architecture defined: $ARCH"
    found=1
    opkg_repos="${opkg_repos}src/gz feedly_${ARCH} https://spatiumstas.github.io/feedly/${ARCH}"
  fi
done <<EOF
$(/opt/bin/opkg print-architecture)
EOF

if [ "$found" -eq 0 ]; then
  echo "No supported architectures found" >&2
  exit 1
fi

opkg install wget-ssl
mkdir -p /opt/etc/opkg
printf "%s\n" "$opkg_repos" > /opt/etc/opkg/feedly.conf

for old_repo in /opt/etc/opkg/keensnap.conf /opt/etc/opkg/sms2gram.conf /opt/etc/opkg/web4static.conf; do
  [ -f "$old_repo" ] && rm -f "$old_repo"
done

opkg update

exit 0
