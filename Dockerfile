FROM alpine:latest

WORKDIR /autMan

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
	&& apk add --no-cache bash bash-doc bash-completion libaio libnsl libc6-compat tzdata \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    	&& echo "Asia/Shanghai" > /etc/timezone
# 安装中文语言包
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
    
RUN apk --no-cache add ca-certificates \ 
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \ 
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk \ 
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-bin-2.29-r0.apk \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-i18n-2.29-r0.apk \
    && apk add glibc-2.29-r0.apk glibc-bin-2.29-r0.apk glibc-i18n-2.29-r0.apk \
    && rm -rf /usr/lib/jvm glibc-2.29-r0.apk glibc-bin-2.29-r0.apk  glibc-i18n-2.29-r0.apk \
    && /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true \
    && echo "export LANG=$LANG" > /etc/profile.d/locale.sh \
    && apk del glibc-i18n
    
RUN mkdir /app \
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
