# est-docker
Containerized version of [GlobalSign EST server/client](https://github.com/globalsign/est), for TESTING and DEVELOPMENT purposes only.

## build and run
```bash
# build
sudo docker build -t arlotito.azurecr.io/globalsign-est-server:1.0.6 --build-arg SERVER_CN="est.arturol76.net" ./server

# push
sudo docker push arlotito.azurecr.io/globalsign-est-server:1.0.6

# run
sudo docker run -d -p 8443:8443 --name my-est-server arlotito.azurecr.io/globalsign-est-server:1.0.6
```

## generate self-signed server certificate


```bash
export SERVER_CN="est.arturol76.net"
openssl req -newkey rsa:4096  -x509  -sha512  -days 365 -nodes -subj "/CN=$SERVER_CN" -out server.pem -keyout server.key

# view
openssl x509 -in server.pem -text –noout

# Test SSL certificate 
openssl s_client -connect est.arturol76.net:443 -showcerts
```

## resources
* openssl cheatsheet: https://geekflare.com/openssl-commands-certificates/#:~:text=Create%20a%20Self-Signed%20Certificate%20openssl%20req%20-x509%20-sha256,as%20it%E2%80%99s%20considered%20most%20secure%20at%20the%20moment