FROM nginx:alpine

ADD public /var/www/html
ADD docker/files/etc/nginx/conf.d/app.conf /etc/nginx/conf.d/app.conf
ADD keys/server.crt /etc/nginx/server.crt
ADD keys/server.key /etc/nginx/server.key

RUN chmod 755 -R /var
RUN mkdir -p /var/logs
RUN chmod 400 /etc/nginx/server.key

EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]
