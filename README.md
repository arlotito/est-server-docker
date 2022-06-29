# est-docker
Containerized version of [GlobalSign EST server/client](https://github.com/globalsign/est), for TESTING and DEVELOPMENT purposes only.

## build and run
```bash
# build (creates a self-signed server certificate with CN = $SERVER_URL)
export SERVER_URL="est.arturol76.net"
sudo docker build -t arlotito.azurecr.io/globalsign-est-server:1.0.6 --build-arg $SERVER_URL ./server

# push
sudo docker push arlotito.azurecr.io/globalsign-est-server:1.0.6

# run
sudo docker run -d -p 8443:8443 --name my-est-server arlotito.azurecr.io/globalsign-est-server:1.0.6

# test ssl cert
openssl s_client -connect $SERVER_URL:8443 -showcerts

# get server certificate
echo | openssl s_client -servername $SERVER_URL -connect $SERVER_URL:8443 |\
  sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > server.pem

# get CA
curl https://$SERVER_URL:8443/.well-known/est/cacerts -o cacerts.p7 --cacert ./server.pem
openssl base64 -d -in cacerts.p7 | openssl pkcs7 -inform DER -outform PEM -print_certs -out cacerts.pem
rm cacerts.p7
```

## resources
* openssl cheatsheet: https://geekflare.com/openssl-commands-certificates/#:~:text=Create%20a%20Self-Signed%20Certificate%20openssl%20req%20-x509%20-sha256,as%20it%E2%80%99s%20considered%20most%20secure%20at%20the%20moment