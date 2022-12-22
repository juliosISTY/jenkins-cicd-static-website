FROM nginx
MAINTAINER Jules (landojules535@yahoo.fr)
RUN apt-get update -y && \
    apt-get install git curl -y 
RUN rm -Rf /usr/share/nginx/html/*
RUN git clone https://github.com/diranetafen/static-website-example.git /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
CMD nginx -g 'daemon off;'
