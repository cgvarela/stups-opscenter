#!/bin/sh
# LISTEN_ADDRESS

if [ -z $LISTEN_ADDRESS ] ;
then
    export LISTEN_ADDRESS=$(curl -s -m 4 http://169.254.169.254/latest/meta-data/local-ipv4)
fi
echo "Opscenter IP address is $LISTEN_ADDRESS ..."

if [ -n "$ETCD_URL" ] ;
then
    echo "Using $ETCD_URL to register Opscenter ..."
    curl -sL "${ETCD_URL}/v2/keys/cassandra/opscenter" -XPUT -d value=${LISTEN_ADDRESS} > /dev/null
    if [ $? -gt 0 ] ;
    then
        echo "Failed to register Opscenter with etcd"
        exit 1
    fi
fi

ENABLED_AUTH=${ENABLED_AUTH:-"False"}

if [ "$ENABLED_AUTH" = "True" ] ;
then
    echo "Enabling Opscenter authentication ... "
    sed -i 's:enabled = False:enabled = True:g' /etc/opscenter/opscenterd.conf
fi

echo "Starting Opscenter ..."
/usr/share/opscenter/bin/opscenter -f

# Clean shutdown cleanup
if [ -n "$ETCD_URL" ] ;
then
    curl -sL "${ETCD_URL}/v2/keys/cassandra/opscenter" -XDELETE > /dev/null
fi


