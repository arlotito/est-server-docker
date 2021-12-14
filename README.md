# est-docker
Dockerized version of [this](https://github.com/arlotito/est) EST server, for TESTING and DEVELOPMENT purposes only.

Docker image available on DockerHub: 
![for easy](https://img.shields.io/docker/v/arlotito/est)
## Quick start
The easy way (i.e. default configuration, CA certs generated on the fly and no client TLS authorization): 
```bash
docker run -d -p 8443:8443 --name my-est-server arlotito/est:1.0.6.2 
```

## Advanced configuration
For a more complete setup, with a custom configuration and custom certs persisted on your docker host, follow the steps below.

Make sure you are non-root, then:

```bash
# set the folder that will hold the configuration and certs
export EST_SERVER_HOME="/home/${USER}/est-server"   # change it if needed

# grabs this repo
git clone https://github.com/arlotito/est-server-docker.git $EST_SERVER_HOME
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
export EST_SERVER_PORT=8449                         # change if needed
export EST_SERVER_CONFIG=$EST_SERVER_HOME/config    
export EST_SERVER_NAME="est-server"

sudo docker run -d \
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
Let's connect to the EST server and check the server certificate presented:

```bash
# use your fqdn:port
openssl s_client -showcerts -connect est.arturol76.net:8449 </dev/null \
    | openssl x509 -noout -issuer -subject
```

To optionally verify the certificate against the root, add '-CAfile'
```bash
openssl s_client -showcerts -connect est.arturol76.net:8449 -CAfile ${EST_SERVER_CONFIG}/server/ca-chain.cert.pem </dev/null \
    | openssl x509 -noout -issuer -subject    
```

If the server is up and running is ok, the openssl s_client should connect and return something like:
```
depth=2 C = IT, ST = IT, L = somewhere, O = something, CN = myCA
verify return:1
depth=1 C = IT, ST = IT, O = something, CN = int1
verify return:1
depth=0 C = IT, ST = IT, L = somewhere, O = something, CN = est.arturol76.net
verify return:1
139887641715136:error:14094412:SSL routines:ssl3_read_bytes:sslv3 alert bad certificate:../ssl/record/rec_layer_s3.c:1528:SSL alert number 42
issuer=C = IT, ST = IT, O = art, CN = int1
subject=C = IT, ST = IT, L = somewhere, O = something, CN = est.arturol76.net
```

NOTE: the bad certificate (code 42) means the server demands you authenticate with a certificate, and you did not do so, and that caused the handshake failure. 
Indeed, we configured the EST server for accepting connections from clients presenting a certificate signed by ${EST_SERVER_CONFIG}/clients/ca-chain.cert.pem. To solve that, launch the openssl s_client adding '-key key.pem -cert cert.pem' (pointing to a valid device certificate).

