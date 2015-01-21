---
layout: post
title:  "CSS3 Filters con GSAP"
date:   2015-01-17 03:36:00
categories: [gsap, css3-filters, animation]
---
Soy muy fan de la librería de GSAP desde que era TweenMax para AS3, además de que sigue pateando traseros a las animaciones de jQuery, Angular, las nativas de CSS3 y se da un quienvive con famo.us.

Sin embargo y como todo, deben asegurarse de que es una librería robusta y no pueden experimentar tan fácil con tantas cosas por lo que de momento [los filtros de CSS3 los tienen descartados hasta nuevo aviso](http://greensock.com/forums/topic/6967-css3-filters-support/). Aunque eso no quiere decir que no haya manera de implementarlos como en el código que dejo a continuación:

{% highlight javascript %}
var el = $('img');
var filters = {
	blur: 0,
	brightness: 0
};
TweenLite.to(filters, 0.4, {
	blur: 2,
	brightness: 1.3,
	onUpdate: function() {
		el.css('filter', 'blur(' + filters.blur + 'px) brightness(' + filters.brightness + ')');
		el.css('-webkit-filter', 'blur(' + filters.blur + 'px) brightness(' + filters.brightness + ')');
	}
});
{% endhighlight %}