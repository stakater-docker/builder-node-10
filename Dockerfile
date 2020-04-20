FROM node:10.17.0

RUN echo "deb http://ftp.us.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list \
     &&      apt-get update \
     &&      apt-get remove -y binutils \
     &&      apt-get install -y git xvfb fluxbox x11vnc libgtk2.0-0 libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 jq \
     &&      apt-get clean all

ARG IAM_AUTHENTICATOR_VERSION=0.5.0
RUN curl -o aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${IAM_AUTHENTICATOR_VERSION}/aws-iam-authenticator_${IAM_AUTHENTICATOR_VERSION}_linux_amd64 && \
    chmod +x ./aws-iam-authenticator && \
    mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH && \
    echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD ARG NODE_ENV
ONBUILD ENV NODE_ENV $NODE_ENV
ONBUILD COPY package.json /usr/src/app/
ONBUILD RUN npm install && npm cache clean --force
ONBUILD COPY . /usr/src/app

CMD [ "npm", "start" ]
