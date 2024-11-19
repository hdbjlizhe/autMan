#!/bin/sh

# 代码目录
if [ -z $CODE_DIR ]; then
	CODE_DIR=/autMan
fi

# 获取当前系统架构
ARCH=$(uname -m)

# 如果构架为arm64，则使用arm64架构
if [ $ARCH = "x86_64" ]; then
	ARCH="autMan_amd64.tar.gz"
elif [ $ARCH = "aarch64" ]; then
	ARCH="autMan_arm64.tar.gz"
else
	echo "不支持的架构"
	exit 1
fi

# 代码目录不存在则拷贝
if [ ! -f $CODE_DIR/autMan ]; then
	echo "autMan 不存在"
        echo -e "=================== 第一次配置机器人，时间可能较长 ==================="
	mkdir -p $CODE_DIR
	cd $CODE_DIR
	echo "下载 $ARCH"
	API_RESPONSE=$(curl -s "https://api.github.com/repos/hdbjlizhe/fanli/releases/latest")
	echo "API_RESPONSE: $API_RESPONSE"
	browser_download_url=$(echo "$API_RESPONSE" | jq -r '.assets[] | select(.name == "'$ARCH'").browser_download_url')
	echo "browser_download_url: $browser_download_url"
	curl -L -o $ARCH "$browser_download_url"
	echo "解压"
        tar -zxvf $ARCH
	echo "删除压缩包"
        rm -f $ARCH
	echo "安装 golang依赖"
	cp $CODE_DIR/plugin/golang/go.mod $CODE_DIR/plugin/scripts/
	cd $CODE_DIR/plugin/scripts
        go get -u github.com/beego/beego/v2@master
	go get -u github.com/hdbjlizhe/middleware
	go get github.com/buger/jsonparser
	go get github.com/gin-gonic/gin
	go get github.com/gin-contrib/sse
        go get github.com/chromedp/chromedp
	source /etc/profile
else
 	echo "autMan 存在"
        source /etc/profile
fi

# 进入代码目录
chmod 777 $CODE_DIR
cd $CODE_DIR 
echo "启动"
	chmod 777 autMan
	./autMan
