# Compose Redis Demo

这是一个 DevOps 入门实战项目。

## 项目内容

```text
Flask Web
+ Redis 访问计数
+ Dockerfile 构建镜像
+ Docker Compose 管理多容器
+ GitHub Actions 自动检查
+ GHCR 发布 Docker 镜像
+ self-hosted runner 自动部署到 Ubuntu VM
+ Nginx 反向代理生产服务
+ Redis 备份与恢复
```

## 项目功能

开发环境访问：

```bash
curl localhost:5050
```

生产环境访问：

```bash
curl localhost
```

成功返回类似：

```text
Production App! Visit count: 1
```

## 架构

```text
用户 / curl
  -> Nginx 80 端口
  -> Docker Web 6060 端口
  -> Flask / Gunicorn 5000 端口
  -> Redis 6379 端口
```

## 本地开发

```bash
cp .env.example .env
docker compose up -d --build
curl localhost:5050
```

查看日志：

```bash
docker compose logs web --tail=30
docker compose logs redis --tail=30
```

停止：

```bash
docker compose down
```

## 生产部署

生产目录：

```text
/home/devops/prod-demo
```

部署：

```bash
cd /home/devops/prod-demo
./deploy.sh
```

## 回滚

回滚到指定版本：

```bash
./rollback.sh 26fe78326f255d8ef30992d1e1a406d17b252de4
```

恢复最新版：

```bash
./use-latest.sh
```

## Redis 备份恢复

手动备份：

```bash
./backup-redis.sh
```

恢复备份：

```bash
./restore-redis.sh /home/devops/backups/redis/dump-YYYYMMDD-HHMMSS.rdb
```

定时备份：

```cron
0 2 * * * /home/devops/prod-demo/backup-redis.sh >> /home/devops/logs/redis-backup.log 2>&1
```

## CI/CD 流程

```text
git push
  -> Compose CI 自动检查
  -> Publish Docker Image 构建镜像
  -> 推送镜像到 GHCR
  -> Deploy to VM 自动部署
  -> Ubuntu runner 执行 deploy.sh
  -> Nginx 对外提供服务
```

## 常用命令

```bash
docker compose ps
docker compose logs web --tail=30
docker compose logs redis --tail=30
curl localhost
```

## Runner 服务

```bash
cd /home/devops/actions-runner
sudo ./svc.sh status
sudo ./svc.sh restart
```
