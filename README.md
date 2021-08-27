<<<<<<< HEAD
# est-docker
Dockerized version of [this](https://github.com/arlotito/est) EST server, for TESTING and DEVELOPMENT purposes only.

Docker image available on DockerHub: 
![for easy](https://img.shields.io/docker/v/arlotito/est)
## Quick start
The easy way (i.e. default configuration, CA certs genereted on the fly and no client TLS authorization): 
```bash
docker run -d -p 8443:8443 --name my-est-server arlotito/est:1.0.6.2 
```

## Advanced configuration
For a more complete setup, with a custom configuration and custom certs persisted on your docker host, follow the steps below.

```bash
# set the folder that will hold the configuration and certs
export EST_SERVER_HOME="<your-path>"   #example: /home/arturo/est-server

# create the folder if it does not exist
mkdir -p $EST_SERVER_HOME

# grabs this repo
git clone https://github.com/arlotito/est-server-docker.git .
```

Add the certs and customize the configuration: 
```bash
<somewhere-on-your-docker-host>
    est-server-config
        |--> ca/         # put here your CA certs (pub and private key).
        |                   # example:
        |                   #   'ca-chain.cert.pem'     --> CA fullchain
        |                   #   'intermediate.key.pem'  --> key
        |
        |--> clients/    # put here the clients' chain for TLS authentication (pub cert only)
        |                   # example:
        |                   #   'ca-chain.cert.pem', ...
        |
        |--> server/     # put here the server TLS certificate (pub cert and private key)
        |                   # example:
        |                   #   'est.arturol76.net.fullchain.cert.pem' --> cert with fullchain
        |                   #   'est.arturol76.net.key.pem' --> private key
        |
        |--> server.cfg # create a 'server.cfg' starting from the 'server.cfg.template' and customize to your needs
```

Here's a sample 'server.cfg' configuration:
```
{
    "mock_ca": {
        "certificates": "/var/lib/est/ca/ca-chain.cert.pem",
        "private_key": "/var/lib/est/ca/intermediate.key.pem"
    },
    "tls": {
        "listen_address": "0.0.0.0:8443",
        "certificates": "/var/lib/est/server/est.arturol76.net.fullchain.cert.pem",
        "private_key": "/var/lib/est/server/est.arturol76.net.key.pem",
        "client_cas": [
            "/var/lib/est/clients/ca-chain.cert.pem"
        ]
    },
    "allowed_hosts": []
}
```

Run the docker container:
```bash
sudo su
export EST_SERVER_PORT=<your-port>                  #example: 8449
export EST_SERVER_CONFIG=$EST_SERVER_HOME/config    #example: /home/arturo/est-server
export EST_SERVER_NAME="est-server"

    -p ${EST_SERVER_PORT}:8443 \
    -v ${EST_SERVER_CONFIG}/server.cfg:/etc/est/config/server.cfg \
    -v ${EST_SERVER_CONFIG}/server:/var/lib/est/server:ro \
    -v ${EST_SERVER_CONFIG}/ca:/var/lib/est/ca:ro \
    -v ${EST_SERVER_CONFIG}/clients:/var/lib/est/clients:ro \
    -v ${EST_SERVER_HOME}/log:/var/log \
    --name ${EST_SERVER_NAME} \
    arlotito/est:1.0.6.2 \
    /go/bin/estserver -config /etc/est/config/server.cfg
```

## Test it
TBD


=======
# est-server-docker
Dockerized version of [this](https://github.com/arlotito/est) EST server, for TESTING and DEVELOPMENT purposes only.

Docker image available on DockerHub: 
![for easy](https://img.shields.io/docker/v/arlotito/est)
## Quick start
To run in Docker in the simplest form, i.e. using the default configuration, CA certs genereted on the fly and no client authorization: 
```bash
docker run -d -p 8443:8443 --name my-est-server arlotito/est:1.0.6.2 
```

## Advanced configuration
For a more complete setup, with a custom configuration and certs persisted on your docker host, follow the steps below.


Copy the ./config folder and its content to your docker host:
```bash
cp -R ./config <somewhere-on-your-docker-host>/est-server-config
```

Add the certs and customize the configuration: 
```bash
<somewhere-on-your-docker-host>
    est-server-config
        |--> certs      # put here your server and CA certs.
        |               # example:
        |               #   'server.fullchain.pem', 'server.key.pem'
        |               #   'CA.pem', 'CA.key.pem'
        |
        |--> clients    # put here the clients' CAs for TLS authentication
        |               # example:
        |               #   'client-CA1.pem', 'client-CA2.pem'
        |
        |--> server     # create a 'server.cfg' from the template and customize to your needs
        |               # example:
        |               #   'server.cfg'

```

Run the docker container:
```bash
docker run -d \
    -p 8443:8443 \
    -v <somewhere-on-your-docker-host>/est-config/certs:/var/lib/est/certs:ro \
    -v <somewhere-on-your-docker-host>/est-config/certs:/var/lib/est/certs:ro \
    -v <somewhere-on-your-docker-host>/est-config/clients:/var/lib/est/clients \
    -v <somewhere-on-your-docker-host>/est-config/sever:/etc/est \
    --name est-server-idevid \
    arlotito/est:1.0.6.2 \
    /go/bin/estserver -config /etc/est/server.cfg
```

## Test it
TBD


>>>>>>> fd781aee8e0ec360667e128e047de8bdd05c45cf
