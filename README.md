# 基于Hexo框架语雀文章博客模板

## 预览

博客预览： [https://haysalan.github.io/](https://haysalan.github.io/)

## 特点

- 支持在线一键部署或更新博客
- 支持拉取语雀文章自动更新博客内容
- ~~支持自定义github actons或gitee工作流~~ (gitee pages 下线无法进行同步)
- 高度可配置，支持自定义部署脚本

## 使用

### 第一步 新建仓库

> 新建两个仓库

一个私有仓库（名称随意）用于存放hexo博客配置等文件
一个开源仓库 yourname.github.io （替换成你的用户名）

### 第二步 配置私有仓库环境变量

1.github个人设置创建token 给与workflow权限以及无时间期限。
![image.png](https://cdn.nlark.com/yuque/0/2024/png/26634545/1708004138179-a9745680-2e72-416d-bba9-00913ab4e7cb.png#averageHue=%23fefcf8&clientId=u19099788-83ff-4&from=paste&height=740&id=u89e4af88&originHeight=1110&originWidth=1894&originalType=binary&ratio=1.5&rotation=0&showTitle=false&size=171807&status=done&style=none&taskId=u6f965fa4-65e1-44a8-aaeb-17b680d0756&title=&width=1262.6666666666667)

2.将github token 配置到你的私有仓库中。**名称需一致**。
![image.png](https://cdn.nlark.com/yuque/0/2024/png/26634545/1708000324358-713596cf-6b43-47b7-8e7e-7d80a21466d2.png#averageHue=%23fefefe&clientId=u22a9482c-048f-4&from=paste&height=806&id=u4587f0a2&originHeight=1209&originWidth=1920&originalType=binary&ratio=1.5&rotation=0&showTitle=false&size=130041&status=done&style=none&taskId=u8942af84-1ea7-4e08-8012-9876e0fe226&title=&width=1280)

3.进入语雀网页版个人设置，获取语雀token（现在需要超级会员才能创建，有之前创建的好的可直接使用）
![image.png](https://cdn.nlark.com/yuque/0/2024/png/26634545/1708001750001-786dbfbf-4cc0-4ad0-b912-1f5d800cbb4b.png#averageHue=%239d9d9d&clientId=u22a9482c-048f-4&from=paste&height=705&id=u633a491f&originHeight=1058&originWidth=1974&originalType=binary&ratio=1.5&rotation=0&showTitle=false&size=98460&status=done&style=none&taskId=u24c28be8-539c-4b05-9d12-27a8d1a0f0b&title=&width=1316)

4.将语雀token配置到私有仓库中 **名称需一致**。
![image.png](https://cdn.nlark.com/yuque/0/2024/png/26634545/1708000395322-ba9dfab1-e87f-445d-aaa5-b774e992de19.png#averageHue=%23fefdfd&clientId=u22a9482c-048f-4&from=paste&height=769&id=ue5213370&originHeight=1153&originWidth=1858&originalType=binary&ratio=1.5&rotation=0&showTitle=false&size=180849&status=done&style=none&taskId=u4bbdad0e-6a5b-4488-a562-01a206bcbf9&title=&width=1238.6666666666667)

### 第三步 修改actions

目录 `.github/workflows/blog-update.yml` 
将其中的PUBLISH_REPOSITORY 修改为你的开源仓库路径。
目录：`actions/gitee-sync.yml`
`actions` 目录下存放开源仓库的工作流，用于在开源仓库触发执行。`gitee-sync.yml `基于 [yanglbme /gitee-pages-action](https://github.com/yanglbme/gitee-pages-action) 根据注释就行配置即可。
`gitee-sync.yml` 用于同步`github pages` 同步到`gitee pages` 可自动更新`gitee pages` 无需 `gitee pages pro`。

### 第四步 自定义部署

默认使用anzhiyu主题，可自行更换。
安装hexo主题或依赖请修改 `blog-update.yml`。
构建博客静态文件前后指令添加请修改`script/generate.sh`。
