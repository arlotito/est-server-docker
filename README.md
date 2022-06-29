# est-docker
Containerized version of [GlobalSign EST server/client](https://github.com/globalsign/est), for TESTING and DEVELOPMENT purposes only.

## build and push
```bash
TAG=1.0.6

# build
sudo docker build -t arlotito.azurecr.io/globalsign-est-server:$TAG ./server

# push
sudo docker push arlotito.azurecr.io/globalsign-est-server:$TAG
```

## create certificates
```bash
SERVER_CN="est.arturol76.net"
CA_CN="my EST CA"

mkdir ./est-certs
cd ./est-certs

# create server self-signed certificate
openssl req -newkey rsa:4096  -x509  -sha512  -days 365 -nodes -subj "/CN=${SERVER_CN}" -out server.pem -keyout server.key

# create CA self-signed certificate
openssl req -newkey rsa:4096  -x509  -sha512  -days 365 -nodes -subj "/CN=${CA_CN}/C=US/ST=Somewhere/L=Here/O=MyOrg" -out ca.pem -keyout ca.key

# fix permissions
chmod 0444 server.pem ca.pem
chmod 0400 server.key ca.key

cd ..
```

## run (default configuration)
```bash
sudo docker stop my-est-server
sudo docker rm my-est-server

sudo docker run -d \
  -p 8443:8443 \
  -v $(pwd)/est-certs:/var/lib/est \
  --name my-est-server \
  arlotito.azurecr.io/globalsign-est-server:$TAG
```

## run (override configuration)
```bash
sudo docker stop my-est-server
sudo docker rm my-est-server

sudo docker run -d \
  -p 8443:8443 \
  -v $(pwd)/server.cfg:/etc/est/server.cfg \
  -v $(pwd)/est-certs:/var/lib/est \
  --name my-est-server \
  arlotito.azurecr.io/globalsign-est-server:$TAG
```

## test ssl cert
```bash
SERVER_URL="est.arturol76.net"

openssl s_client -connect $SERVER_URL:8443 -showcerts
```

## get server certificate
```bash
echo | openssl s_client -servername $SERVER_URL -connect $SERVER_URL:8443 |\
  sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > server.pem
```

## get CA
```bash
curl https://$SERVER_URL:8443/.well-known/est/cacerts -o cacerts.p7 --cacert ./server.pem
openssl base64 -d -in cacerts.p7 | openssl pkcs7 -inform DER -outform PEM -print_certs -out cacerts.pem
rm cacerts.p7
```

## resources
* openssl cheatsheet: https://geekflare.com/openssl-commands-certificates/#:~:text=Create%20a%20Self-Signed%20Certificate%20openssl%20req%20-x509%20-sha256,as%20it%E2%80%99s%20considered%20most%20secure%20at%20the%20moment