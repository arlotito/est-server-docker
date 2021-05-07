# est-docker
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


