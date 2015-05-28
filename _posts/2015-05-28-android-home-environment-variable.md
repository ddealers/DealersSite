---
layout: post
comments: true
title:  "Añadir ANDROID_HOME al path en MAC OS"
author: vampaynani
date:   2015-05-28 00:00:00
categories: [android, mobile, sdk, path, development]
---
Siempre que se vaya a utilizar el Android SDK con algún compilador externo, llámese Adobe AIR, Phonegap, Cordova, etc. Es necesario agregar ANDROID_HOME como *environment variable*, o en español, que las herramientas del SDK de Android se puedan ejecutar desde cualquier ubicación en nuestro sistema de archivos. A continuación dejo una lista de pocos pasos para agregar esta útil variable sin dolor.

Descargar e Instalar **Android Studio** desde:
[https://developer.android.com/sdk/](https://developer.android.com/sdk/index.html)


Instalar desde el **SDK Manager**:

- Tools > Android SDK Tools
- Tools > Android SDK Platform-tools
- Tools > Android SDK Build-tools
- SDK Platform (most recent version)> SDK Platform
- SDK Platform (most recent version) > ARM EABI v7a System Image
- Extras -> Android Support Repository
- Extras > Android Support Library
- Extras -> Google Repository
- Extras > Intel x86 Emulator Accelerator (HAXM installer)


En la **Terminal** escribir:
{% highlight bash %}
sudo nano ~/.bash_profile.
{% endhighlight %}


En el archivo que se genera escribir lo siguiente:
{% highlight bash %}
export ANDROID_HOME=/Users/<nombre_del_usuario>/Library/Android/sdk
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
{% endhighlight %}
Para cerrarlo, presionar **ctrl+x** después **Y** y por último, **enter**.

Para corroborar el path de **ANDROID_HOME**, revisar la parte superior del **SDK Manager**, el campo de **SDK Path**:

Cerrar esa ventana de la terminal y abrir una nueva para que el path se refresque e incluya las tools de Android que se han agregado.

Para probar y de paso saber que dispositivos Android están conectados a la pc y disponibles, tanto reales como virtuales usar la instrucción:
{% highlight bash %}
adb devices
{% endhighlight %}

Y listo, el Android SDK y todas sus herramientas están disponibles para ser ejecutados desde cualquier ruta.