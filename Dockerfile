FROM node:12.14.1-buster-slim as build-deps

WORKDIR /usr/src/app

ENV DOWNLOAD_URL https://github.com/MyCryptoHQ/MyCrypto.git

RUN apt-get update && \ 
    apt-get install -y git g++ build-essential python
	
RUN git clone $DOWNLOAD_URL

RUN sed -i 's/setSecureCookie: true/setSecureCookie: false/g' "MyCrypto/src/services/Analytics/Analytics.ts";

RUN cd MyCrypto && \
	yarn install --network-timeout 1000000 && \
    yarn build

FROM nginx:stable

COPY --from=build-deps /usr/src/app/MyCrypto/dist/web /usr/share/nginx/html



ENTRYPOINT nginx -g 'daemon off;'
