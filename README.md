docker-ssl-nginx
===

## Initialize commands

```bash
gibo dump JetBrains macOS > .gitignore
```

## Generate keys

### Generate a secret-key for CA

```bash
openssl genrsa -out ca.key 2048
```

```
Generating RSA private key, 2048 bit long modulus
...............................................................................................+++
..............................+++
e is 65537 (0x10001)
```

### Generate a certification from the secret-key for CA

```bash
openssl req -new -x509 -days 3650 -key ca.key -out ca.crt
```

```
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) []:
State or Province Name (full name) []:
Locality Name (eg, city) []:
Organization Name (eg, company) []:
Organizational Unit Name (eg, section) []:
Common Name (eg, fully qualified host name) []:example.com
Email Address []:
```

```bash
# Browse the certification
openssl x509 -text -in ca.crt -noout
```

### Generate a secret-key for Application Server

```bash
openssl genrsa -out server.key 2048
```

```
Generating RSA private key, 2048 bit long modulus
................................................................................................+++
....................................+++
e is 65537 (0x10001)
```

###　Generate a certification request from the secret-key for Application Server

```bash
openssl req -new -key server.key -out server.csr
```

```
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) []:
State or Province Name (full name) []:
Locality Name (eg, city) []:
Organization Name (eg, company) []:
Organizational Unit Name (eg, section) []:
Common Name (eg, fully qualified host name) []:example.jp
Email Address []:

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
```

```bash
openssl req -text -in server.csr -noout
```

### Generate a certificate for Application Server from CA's both the secret-key and the certification using the certification request

```bash
openssl x509 -req -days 3650 -CA ca.crt -CAkey ca.key -CAcreateserial -in server.csr -out server.crt
```

```
Signature ok
subject=/CN=example.jp
Getting CA Private Key
```

```bash
openssl x509 -text -in server.crt -noout
```


## Docker commands

```bash
docker image build --no-cache -t kei711/docker-ssl-nginx:latest .

docker container run -d --name docker-ssl-nginx -p 8443:443 -p 8080:80 kei711/docker-ssl-nginx:latest
docker container ps -a
docker container rm -f docker-ssl-nginx
docker container exec -it docker-ssl-nginx ash

docker logs -f docker-ssl-nginx
```


# References

- https://qiita.com/murank/items/41bb0cecfe8c8b65220e
- https://katekichi.hatenablog.com/entry/2017/06/14/docker_for_mac_%2B_nginx_%2B_%E3%82%AA%E3%83%AC%E3%82%AA%E3%83%AC%E8%A8%BC%E6%98%8E%E6%9B%B8%E3%81%A7%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%ABSSL%E7%92%B0%E5%A2%83%E3%82%92%E4%BD%9C%E3%81%A3%E3%81%9F

