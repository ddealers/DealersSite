---
layout: post
title:  "Técnicas de cifrado con PHP"
author: vampaynani
date:   2015-02-20 00:00:00
categories: [code, snippet, php, encryption]
---
En muchos de los proyectos que realizamos en la agencia tenemos la necesidad de cifrar información, para lo cual PHP nos brinda la ayuda de diversas librerías con las cuales podemos hacer cifrado, de una vía o simétrico(cifrar y descifrar el mensaje) y a continuación escribo los ejemplos de algunas de estas formas con PHP puro.

## Cifrado de una vía
**En este tipo de cifrado el texto se convierte en una cadena de rastreo con un algoritmo predefinido, siendo casi imposible descifrar el texto que origino esta cadena.**

{% highlight php %}
//Texto legible
$msg = "Hola Mundo";
//Texto cifrado
$encrypted = mhash( MHASH_CRC32, $msg );

echo $msg;
echo $encrypted;
{% endhighlight %}
La función mhash acepta diversos tipos de constante para pasar como primer argumento del cifrado, la lista completa se encuentra en la [documentación de PHP](http://php.net/manual/en/mhash.constants.php)

## Cífrado simétrico
**Este cifrado utiliza una llave, esto permite que el texto se convierta en un texto cifrado el cual a su vez, si se cuenta con la llave correcta puede ser descifrado y convertido a texto legible.**

{% highlight php %}
//Texto legible
$msg = "Hola Mundo";
//Llave
$key = "Abrete Sesamo"
echo $msg . ' :: ' . $key;
//Texto cifrado
$encrypted = mcrypt_ecb( MCRYPT_DES, $key, $msg, MCRYPT_ENCRYPT );
echo $encrypted;
//Texto descifrado
$decrypted = mcrypt_ecb( MCRYPT_DES, $key, $msg, MCRYPT_DECRYPT );
echo $decrypted;
{% endhighlight %}

Cómo se ve en el código, la función mcrypt_ecb sirve para cifrar y descifrar un texto determinado siempre y cuando se cuente con la llave correcta. No hay que olvidar tomar en cuenta que MCRYPT_ENCRYPT se usa para cifrar el mensaje mientras que MCRYPT_DECRYPT se usa para descifrarlo.