FROM debian:latest

WORKDIR /autMan

RUN mkdir /app \
	&& cd /app \
	&& apt update \
	&& apt add curl \
	&& apt add jq \
	&& apt add wget \
	&& apt add tar \
	&& apt add python3 \
	&& apt add go \
	&& apt add py3-pip \
	&& apt add nodejs \
	&& apt add npm \
	&& apt add php php-cli php-fpm php-mysqli php-json php-openssl \
	&& apt add icu-data-full \
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
	&& apt add git \
  	&& apt add bash \
	&& apt add ffmpeg \
        && apt add chromium
 	# && cd /app/autMan/plugin/scripts \
	# && go get -u github.com/hdbjlizhe/middleware\
	# && go get github.com/buger/jsonparser\
	# && go get github.com/gin-gonic/gin\
	# && go get github.com/gin-contrib/sse

ENTRYPOINT ["/bin/docker-entrypoint.sh"]
