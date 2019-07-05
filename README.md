# ghidra-server-docker


This is a minimal docker configuration to start a ghidra server. This repo is mainly for noting down all the tears shed when setting this up.

### Usage
1. Change the `ARGS` in ghidra-server/Dockerfile, namely the Ghidra version and hash.
2. Change the `hostname` in docker-compose.yml.

```
docker-compose up
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

The solution to this is to run the Docker container in the host network, instead of NAT, as seen in the following example of a `docker-compose` config:

```
version: '3'

services:
  ghidra:
    build: ./ghidra-server-docker
    container_name: ghidra-server
    network_mode: host
    hostname: <your hostname>
    volumes:
      - "main:/data"

volumes:
  main:
```

This docker container is used in a side project [pwnbro](https://github.com/Enigmatrix/pwnbro).

#### Doesn't work on Mac
[docker/for-mac#1031](https://github.com/docker/for-mac/issues/1031) explains why. Makes no sense to host a Ghidra server on a Mac anyways.
