---
# Only the main Sass file needs front matter (the dashes are enough)
---
app = angular.module 'DealersSite',['ngAnimate']
app.run()		
.config ($interpolateProvider)->
	$interpolateProvider.startSymbol('//-').endSymbol('-//');
.directive 'section', ($window, $document)->
	restrict: 'E'
	link: (scope, elem, attrs)->
		w = angular.element $window
		angular.element(document).ready ->
			elem.css 'min-height', $window.outerHeight+'px'
		w.on 'resize', (e)->
			elem.css 'min-height', $window.outerHeight+'px'
.directive 'mainMenu', ($window, $document, $interval)->
	parallax = (scope, first)->
		stop = $interval( ()->
			wt = $window.scrollY
			ft = first.offset().top
			if wt <= ft / 2
				scope.logo = true
			else
				scope.logo = false
		, 100)
	getScrollY = ()->
		documentScroll = if document.documentElement.scrollTop is not null then document.documentElement.scrollTop else document.body.scrollTop
		scrollY = if window.pageYOffset is not null then window.pageYOffset else documentScroll
	restrict: 'A'
	link: (scope, elem, attrs)->
		first = $document.find 'section#about'
		menuIcon = elem.find '.menu-icon'
		closeMenu = elem.find '.close-menu'
		item = elem.find 'li a'
		menu = angular.element 'aside'
		isOpen = false

		scope.logo = false

		TweenLite.set 'aside', {width: 0}
		if first.length > 0
			scope.logo = true
			parallax(scope, first)

		menuIcon.on 'click', (e)->
			e.preventDefault()
			if not isOpen
				TweenLite.to 'nav', 0.2, {top:-100, ease: Sine.easeOut}
				TweenLite.to 'aside', 0.2, {width: '100%', ease: Sine.easeIn}
			isOpen = true
		closeMenu.on 'click', (e)->
			e.preventDefault()
			if isOpen
				tl = new TimelineLite()
				tl.to 'aside', 0.4, {width: 0, ease: Back.easeIn}
				tl.to 'nav', 0.2, {top:0, ease: Back.easeOut}
			isOpen = false
		item.on 'click', (e)->
			e.preventDefault()
			anchor = angular.element @
			section = angular.element anchor.attr 'href'
			scroll = y: getScrollY()
			if isOpen
				tl = new TimelineLite()
				tl.to window, 0.4, {scrollTo:{y: section.offset().top}, ease: Sine.easeOut}
				tl.to 'aside', 0.4, {width: 0, ease: Back.easeIn}
				tl.to 'nav', 0.2, {top:0, ease: Back.easeOut}
			isOpen = false
.directive 'portfolioList', ()->
	restrict: 'C'
	link: (scope, elem, attrs)->
		items = elem.find 'li'
		items.each ()->
			_this = angular.element @
			anchor = _this.find 'a'
			back = _this.find 'div'
			filters = 
				blur: 0
				brightness: 0
			TweenLite.set anchor, {opacity: 0, scale: 0.6}
			_this.on 'mouseenter', ()->
				TweenLite.to filters, 0.4, {blur: 2, brightness: 1.3, onUpdate: ()->
					back.css 'filter', 'blur('+filters.blur+'px) brightness('+filters.brightness+')'
					back.css '-webkit-filter', 'blur('+filters.blur+'px) brightness('+filters.brightness+')'
				}
				TweenLite.to back, 0.4, {opacity: 0.45}
				TweenLite.to anchor, 0.6, {opacity: 1, scale: 1, ease: Back.easeOut}
			_this.on 'mouseleave', ()->
				TweenLite.to filters, 0.4, {blur: 0, brightness: 1, onUpdate: ()->
					back.css 'filter', 'blur('+filters.blur+'px) brightness('+filters.brightness+')'
					back.css '-webkit-filter', 'blur('+filters.blur+'px) brightness('+filters.brightness+')'
				}
				TweenLite.to back, 0.4, {opacity: 1, ease: Strong.easeIn}
				TweenLite.to anchor, 0.4, {opacity: 0, scale: 0.6, ease: Strong.easeIn}
.animation '.bg-opacity', ()->
	enter = (element, className, done)->
		if className is not 'active' then return;
		TweenLite.to element, 0.4, {'backgroundColor': 'rgba(0,184,191,0)', onComplete: done}
		(cancel)->
			if cancel then element.stop()
	leave = (element, className, done)->
		if className is not 'active' then return;
		TweenLite.to element, 0.4, {'backgroundColor': 'rgba(0,184,191,0.5)', onComplete: done}
		(cancel)->
			if cancel then element.stop()
	addClass: enter,
	removeClass: leave
.animation '.fade', ()->
	fadeIn = (element, className, done)->
		if className is not 'ng-hide' then return;
		TweenLite.to element, 0.4, {opacity: 1, onComplete: done}
		(cancel)->
			if cancel then element.stop()
	fadeOut = (element, className, done)->
		if className is not 'ng-hide' then return;
		TweenLite.to element, 0.4, {opacity: 0, onComplete: done}
		(cancel)->
			if cancel then element.stop()
	beforeAddClass: fadeOut
	removeClass: fadeIn