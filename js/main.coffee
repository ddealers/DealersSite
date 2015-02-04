---
# Only the main Sass file needs front matter (the dashes are enough)
---
app = angular.module 'siteDealers',['ngAnimate']
app.run()		
.config ($interpolateProvider)->
	$interpolateProvider.startSymbol('//-').endSymbol('-//');
.controller 'PortfolioController', ($scope, $http)->
	$scope.portfolioUrl = null
	$scope.showPortfolio = (e)->
		e.preventDefault()
		$scope.portfolioUrl = angular.element(e.currentTarget).attr('href')
		TweenLite.fromTo '.portfolio-meta', 1, {opacity: 0, x: -100}, {opacity: 1, x: 0, delay: 1}
	$scope.hidePortfolio = (e)->
		e.preventDefault()
		$scope.portfolioUrl = null

.directive 'section', ($window, $document)->
	restrict: 'E'
	link: (scope, elem, attrs)->
		w = angular.element $window
		angular.element(document).ready ->
			elem.css 'min-height', $window.innerHeight+'px'
		w.on 'resize', (e)->
			elem.css 'min-height', $window.innerHeight+'px'

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
		closeMenu = elem.find '.ion-close'
		item = elem.find 'li a'
		menu = angular.element 'aside'
		isOpen = false
		scope.logo = false
		
		TweenLite.set 'aside', {width: 0}
		
		if first.length > 0
			scope.logo = true
			parallax(scope, first)

		menuIcon.on 'click', (e)->
			tl = new TimelineMax()
			e.preventDefault()
			if not isOpen
				tl.to 'nav', 0.2, {top:-100, ease: Sine.easeOut}
				tl.to 'aside', 0.2, {width: '100%', ease: Sine.easeIn}
				tl.staggerFrom 'aside li', 1.2, {transformOrigin:"50% top", rotationX: -45, opacity: 0, ease: Elastic.easeOut}, 0.2
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

.directive 'ionClose', ()->
	restrict: 'C'
	link: (scope, elem, attrs)->
		elem.on 'mouseenter', (e)->
			TweenLite.to elem, 0.4, {color:'#333', ease: Power2.easeOut}
		elem.on 'mouseleave', (e)->
			TweenLite.to elem, 0.4, {color:'#FFF', ease: Power2.easeOut}

.directive 'menuItem', ()->
	restrict: 'C'
	link: (scope, elem, attrs)->
		elem.on 'mouseenter', (e)->
			TweenLite.to elem, 0.4, {color:'#333', ease: Power2.easeOut}
		elem.on 'mouseleave', (e)->
			TweenLite.to elem, 0.4, {color:'#FFF', ease: Power2.easeOut}

.directive 'portfolioMetaLink', ()->
	restrict: 'C'
	link: (scope, elem, attrs)->
		elem.on 'mouseenter', (e)->
			TweenLite.to elem, 0.4, {color:'#00b8bf', backgroundColor: '#FFF', ease: Power2.easeOut}
		elem.on 'mouseleave', (e)->
			TweenLite.to elem, 0.4, {color:'#FFF', backgroundColor: '#00b8bf', ease: Power2.easeOut}

.directive 'portfolioList', ()->
	pageItems = 12
	totalItems = 0
	totalPages = 0
	currentPage = 0
	gotoPage = (pageNum, items)->
		startFrom = pageNum * pageItems
		endOn = startFrom + pageItems
		items.css('display', 'none').slice(startFrom, endOn).css('display', 'block')
		currentPage = pageNum
	restrict: 'C'
	link: (scope, elem, attrs)->
		items = elem.find 'li'
		totalItems = items.size()
		totalPages = Math.ceil totalItems / pageItems
		gotoPage currentPage, items
		
		items.each ()->
			_this = angular.element @
			anchor = _this.find 'a'
			back = _this.find 'div'
			filters = 
				blur: 0
				brightness: 0
			
			TweenLite.set anchor, {opacity: 0, y: -100}
			
			_this.on 'mouseenter', ()->
				TweenLite.to filters, 0.4, {blur: 2.5, brightness: 1.6, onUpdate: ()->
					back.css 'filter', 'blur('+filters.blur+'px) brightness('+filters.brightness+')'
					back.css '-webkit-filter', 'blur('+filters.blur+'px) brightness('+filters.brightness+')'
				}
				TweenLite.to back, 0.4, {borderBottomRightRadius: '0px', borderTopLeftRadius: '0px'}
				TweenLite.set anchor, {scale: 1, y: -100}
				TweenLite.to anchor, 0.2, {opacity: 1, y: 0, delay: 0.2, ease: Back.easeOut}
			_this.on 'mouseleave', ()->
				TweenLite.to filters, 0.4, {blur: 0, brightness: 1, onUpdate: ()->
					back.css 'filter', 'blur('+filters.blur+'px) brightness('+filters.brightness+')'
					back.css '-webkit-filter', 'blur('+filters.blur+'px) brightness('+filters.brightness+')'
				}
				TweenLite.to back, 0.4, {borderBottomRightRadius: '20px', borderTopLeftRadius: '20px'}
				TweenLite.to anchor, 0.4, {opacity: 0, scale: 5, delay: 0.2, ease: Back.easeIn}

.directive 'blogList', ()->
	restrict: 'C'
	link: (scope, elem, attrs)->
		items = elem.find 'li'
		items.each ()->
			_this = angular.element @
			p = _this.find 'p'

			_this.on 'mouseenter', ()->
				tl = new TimelineLite
				tl.to _this, 0.3, {height:'6rem', backgroundColor: '#00b8bf', borderWidth: '0px', ease: Strong.easeIn}
				tl.to p, 0.2, {opacity:1, y: 0, ease: Back.easeOut} 
			_this.on 'mouseleave', ()->
				tl = new TimelineLite
				tl.to p, 0.2, {opacity:0, y: '-10px', ease: Back.easeIn} 
				TweenLite.to _this, 0.3, {height: '2rem', backgroundColor: '#ffffff', borderWidth: '2px', ease: Back.easeIn}


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