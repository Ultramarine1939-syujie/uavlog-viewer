# UAV Log Viewer(本分支为纯离线模式)

![log seeking](demo.png "Logo Title Text 1")

![log seeking](demo2.png "Logo Title Text 1")

 This is a Javascript based log viewer for Mavlink telemetry and dataflash logs.
 [Live demo here](http://plot.ardupilot.org).

## 运行环境

```bash
ubuntu 22.04 + nodejs v18.18.2 + npm 9.8.1
ubuntu 20.04 + nodejs v16.20.2 + npm 8.19.4
```

## Usage

```bash
cd deploy
./build.sh
#uavlogviewer.service里的用户名记得改
```

```shell
#node 18.0 install
sudo apt-get install -y curl
curl -fsSL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh
sudo -E bash nodesource_setup.sh
sudo rm nodesource_setup.sh
sudo apt install nodejs -y
```

## Build Setup

``` bash
# install dependencies
npm install

# serve with hot reload at localhost:8080
npm run dev

# build for production with minification
# dist 用于部署
npm run build

# run unit tests
npm run unit

# run e2e tests
npm run e2e

# run all tests
npm test
```

# 部署(pm2)

```shell
npm install pm2 -g
cd ./deploy
pm2 start demo.js
```

# 部署(nginx)

将 Vue 应用程序打包后生成的 dist 目录，可以直接部署到服务器上进行访问。下面是一个简单的部署步骤：

1. 将 dist 文件夹复制到服务器上的指定目录下。可以使用 scp 命令（需要先安装 ssh 服务）将本地 dist 目录上传到服务器上。

2. 安装 Web 服务器。可以使用 Nginx 或 Apache 等流行的 Web 服务器。这里以 Nginx 为例，在服务器上运行以下命令进行安装：

   ```shell
   sudo apt-get update
   sudo apt-get install nginx
   ```

3. 配置 Nginx。打开 Nginx 的默认配置文件 /etc/nginx/sites-available/default，并将 root 配置项指向 dist 目录所在的路径。例如，如果 dist 目录位于 /var/www/myapp，则可以在配置文件中添加以下行：

   ```json
   server {
       ...
       root /var/www/myapp/dist;
       ...
   }
   ```

4. 重新启动 Nginx 服务。运行以下命令：

   ```shell
   sudo service nginx restart
   ```

5. 验证部署。在浏览器中输入服务器的 IP 地址或域名，即可访问部署的 Vue 应用程序。

6. 需要注意的是，部署前需要确保服务器已安装了 Node.js 和 NPM，因为 Vue 应用程序需要在服务器上运行打包后的 JavaScript 代码。此外，还需要保证服务器上的端口和 Vue 应用程序中设置的端口一致，否则可能无法访问应用程序。

# Docker

``` bash

# Build Docker Image
docker build -t <your username>/uavlogviewer .

# Run Docker Image
docker run -p 8080:8080 -d <your username>/uavlogviewer

# View Running Containers
docker ps

# View Container Log
docker logs <container id>

# Navigate to localhost:8080 in your web browser

```

## 部分问题解决方案

```
1、code: 'ERR_OSSL_EVP_UNSUPPORTED'
```

**1. 降级到 Node.js v16。（可行）**

**2. 启用旧版 OpenSSL 提供程序。（可行）**

在类 Unix 上（Linux、macOS、Git bash 等）：

```bash
export NODE_OPTIONS=--openssl-legacy-provider
```

```
2、Error: ENOSPC: System limit for number of file watchers reached
```
解决这个问题的方法之一是增加系统中监视器的数量限制
```bash
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```