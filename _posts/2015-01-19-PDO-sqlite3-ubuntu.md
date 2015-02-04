---
layout: post
title:  "Instalar el soporte para Sqlite3 en PHP para PDO"
date:   2015-01-19 00:00:00
categories: [code, snippet, php, PDO, Sqlite3]
---
Dando soporte a uno de nuestros proyectos en el que cualquier opción distinta a Sqlite estaba sobrada, decidimos utilizarlo en conjunto con un script que teníamos desarrollado con PDO ya que la migración en este sentido era sencilla, el problema que encontramos fué que por default Ubuntu no incluye el driver de Sqlite para PDO.

La solución fue sencilla:

{% highlight bash %}
$ sudo apt-get install php5-sqlite
{% endhighlight %}

Aunque uno de nosotros tuvo un problema:

{% highlight bash %}
...
configure: error: Cannot find php_pdo_driver.h.
ERROR: `/tmp/pear/temp/PDO_SQLITE/configure' failed
{% endhighlight %}

El cual solucionamos con:

{% highlight bash %}
$ apt-get --purge remove php5*
$ sudo apt-get install php5 php5-sqlite php5-mysql
{% endhighlight %}