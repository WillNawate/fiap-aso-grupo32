# Solution Sprint de Containerization Strategy

Este repositório contém a entrega do grupo 32 do MBA Arquitetura de Soluções para a solution sprint de containerization strategy.

O conteúdo exposto aqui serve exclusivamente como conteúdo acadêmico e não reflete um ambiente de produção tendo como finalidade a apreciação por parte dos docentes encarregados de avaliar a entrega.

![](https://github.com/WillNawate/fiap-aso-grupo32/blob/54c25d0dcbd12dd0b6b036fbaec8753ab868658a/blog.png)

## Imagem customizada

Foi gerado um arquivo Dockerfile que gera uma imagem customizada do CentOS 8 com um serviço web (httpd) de apenas uma página. Efetuamos o build da imagem via podman e publicamos a mesma em um repositório do Docker Hub [https://hub.docker.com/r/willnawate/fiap-aso-grupo32](https://hub.docker.com/r/willnawate/fiap-aso-grupo32) e para testa-la basta executar os seguintes coomandos:

```
(podman|docker) pull willnawate/fiap-aso-grupo32:latest
(podman|docker) -d --name containerfile -p 8080:80 willnawate/fiap-aso-grupo32


curl 127.0.0.1:8080
```

## Deploy no Openshift

Para a avaliação do Openshift criamos um único arquivo para deploy de uma aplicação de blog em Django e seu respectivo database respeitando e atendendo todas a exigências solicitadas no enunciado.

Para efetuar o deploy da aplicação basta executar 

```
oc apply -f fiap-aso-grupo32.yml
```

Após o deploy dos recursos ser feito é preciso executar o setup do banco de dados para que a aplicação funcione corretamente:

```
POD=`oc get pods --selector app=blog-django -o name`
oc rsh $POD .s2i/action_hooks/setup
```

```
$ oc rsh $POD .s2i/action_hooks/setup
 -----> Running Django database table migrations.
Operations to perform:
  Apply all migrations: admin, auth, blog, contenttypes, sessions
Running migrations:
  No migrations to apply.
 -----> Running Django super user creation
Username (leave blank to use '1001970000'): grupo32
Email address: grupo32@fiap.com
Password:
Password (again):
Superuser created successfully.
 -----> Pre-loading Django database with blog posts.
Installed 2 object(s) from 1 fixture(s)
```

O título do blog e a cor do cabeçalho são customizáveis através do Config Map `blog-settings` que altera o arquivo `blog.json`

```
{
   "BLOG_SITE_NAME": "OpenShift Blog",
   "BLOG_BANNER_COLOR": "red"
}
```

Para desfazer o ambiente basta executar o comando:

```
oc delete -f fiap-aso-grupo32.yml
```

> **obs.:** *pode não ser possível criar ou excluir o projeto dependendo do nível de permissão do usuário sendo necessário faze-lo manualmente através através da web ou CLI.*

```
oc new-project fiap-aso-grupo32
```

```
oc delete project fiap-aso-grupo32
```