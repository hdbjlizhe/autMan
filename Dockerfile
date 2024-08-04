FROM ponycool/alpine-3.16:latest

WORKDIR /autMan

RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 \
	&& ln -s /lib/libc.so.6 /usr/lib/libresolv.so.2 \
	&& apk add --no-cache libaio libnsl libc6-compat \
	&& mkdir /app \
	&& cd /app \
	&& apk update \
	&& apk add curl \
	&& apk add jq \
	&& apk add wget \
	&& apk add tar \
	&& apk add python3 \
	&& apk add go \
	&& apk add py3-pip \
	&& apk add nodejs \
	&& apk add npm \
	&& apk add php php-cli php-fpm php-mysqli php-json php-openssl \
	&& apk add icu-data-full

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
	&& apk add git \
  	&& apk add bash \
	&& apk add ffmpeg \
        && apk add chromium
 	# && cd /app/autMan/plugin/scripts \
	# && go get -u github.com/hdbjlizhe/middleware\
	# && go get github.com/buger/jsonparser\
	# && go get github.com/gin-gonic/gin\
	# && go get github.com/gin-contrib/sse

ENTRYPOINT ["/bin/docker-entrypoint.sh"]
