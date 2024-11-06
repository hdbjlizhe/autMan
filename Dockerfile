FROM debian:latest

WORKDIR /autMan

RUN mkdir /app \
	&& cd /app \
	&& apt update \
	&& apt install curl \
	&& apt install jq \
	&& apt install wget \
	&& apt install tar \
	&& apt install python3 \
	&& apt install go \
	&& apt install py3-pip \
	&& apt install nodejs \
	&& apt install npm \
	&& apt install php php-cli php-fpm php-mysqli php-json php-openssl \
	&& apt install icu-data-full \
        && mv /usr/lib/python3.12/EXTERNALLY-MANAGED /usr/lib/python3.12/EXTERNALLY-MANAGED.bk

RUN pip3 install requests PyExecJS aiohttp bs4 sseclient-py sseclient -i https://pypi.tuna.tsinghua.edu.cn/simple \
	&&npm install pnpm axios request require crypto-js global-agent got@11 dotenv base-64 jquery node-rsa fs png-js cheerio MD5 md5 -g

ADD . /app/autMan/
COPY ./docker-entrypoint.sh /bin/
COPY ./MSYH.TTF /usr/share/fonts/MSYH.TTF

#设置golang环境变量
ENV GO111MODULE=on \
	GOPROXY=https://goproxy.cn \
	NODE_PATH=/usr/local/lib/node_modules

RUN chmod a+x /bin/docker-entrypoint.sh \
	&& apt install git \
  	&& apt install bash \
	&& apt install ffmpeg \
        && apt install chromium

ENTRYPOINT ["/bin/docker-entrypoint.sh"]
