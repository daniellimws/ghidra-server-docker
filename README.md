# ghidra-server-docker

This is a minimal docker configuration to start a ghidra server. This repo is mainly for noting down all the tears shed when setting this up.

### Usage
Change the `ARGS` in the Dockerfile, namely

* Ghidra version and hash
* Hostname - Just ``localhost`` if on localhost, otherwise the IP address or domain name of your remote server.

#### Build
```
docker build . -t ghidra-server
```

#### Run
```

```

### Problems faced
#### Failed to connect to running Ghidra server
Turns out the Java RMI protocol that Ghidra uses needs the following argument to be set. Seems to be a problem when running the server not on localhost? (More info at [ghidra#202](https://github.com/NationalSecurityAgency/ghidra/issues/202#issuecomment-475377958))

```
wrapper.java.additional.4=-Djava.rmi.server.hostname=<your hostname>
```

Weirdly, it only happens to Ghidra clients running on certain computers (e.g. me and the people in the issue linked above), but not on certain others'. ¯\_(ツ)_/¯

#### Failed to checkout binary
After being able to connect to the server, the suffering is not over yet. Everything is fine until realizing checkout doesn't work. It seems to be a problem with running behind a NAT, which was set for the Docker container at that time. (More info at [ghidra#645](https://github.com/NationalSecurityAgency/ghidra/issues/645))

The solution to this is to run the Docker container in the host network, instead of NAT, with the `--network host` argument.

Or an example of a `docker-compose` config:

```
version: '3'

services:
  ghidra:
    build: ./ghidra-server-docker
    container_name: ghidra-server
    network_mode: host
    hostname: <your hostname>
    ports:
      - "13100:13100"
      - "13101:13101"
      - "13102:13102"
```

This docker container is used in a side project [pwnbro](https://github.com/Enigmatrix/pwnbro).
