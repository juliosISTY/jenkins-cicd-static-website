FROM nginx
MAINTAINER Jules (landojules535@yahoo.fr)
RUN groupadd -r julesG -g 433 && \
    useradd -u 431 -r -g julesG -s /sbin/nologin -c "Docker image user" jules
RUN apt-get update -y && \
    apt-get install git curl -y 
RUN rm -Rf /usr/share/nginx/html/*
RUN git clone https://github.com/diranetafen/static-website-example.git /usr/share/nginx/html/ 
COPY nginx.conf /etc/nginx/conf.d/default.conf
CMD nginx -g 'daemon off;' # sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && ... (when deployment in Heroku server)
USER jules