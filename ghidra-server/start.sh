#!/bin/bash

echo "wrapper.java.additional.4=-Djava.rmi.server.hostname=$(hostname)" >> server/server.conf

server/ghidraSvr start
server/ghidraSvr stop

# 2 lines above are for the server to "set up" /srv/repositories, otherwise the following line to add user will fail
server/svrAdmin -add daniellimws
server/ghidraSvr console
