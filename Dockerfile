FROM node:10.16.3

RUN echo "deb http://ftp.us.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list \
     &&      apt-get update \
     &&      apt-get remove -y binutils \
     &&      apt-get install -y git xvfb fluxbox x11vnc libgtk2.0-0 libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 jq \
     &&      apt-get clean all

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD ARG NODE_ENV
ONBUILD ENV NODE_ENV $NODE_ENV
ONBUILD COPY package.json /usr/src/app/
ONBUILD RUN npm install && npm cache clean --force
ONBUILD COPY . /usr/src/app

CMD [ "npm", "start" ]
