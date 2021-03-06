---
# Only the main Sass file needs front matter (the dashes are enough)
---
dealersjs = {}
dealersjs.mobile = class Mobile
	@user_agent = navigator.userAgent.toLowerCase()
	@isIOS = ->
    	if true in [@isIpad(),@isIphone(), @isIpod()] then true else false
    @isIpad = ->
    	@user_agent.indexOf('ipad') > -1
    @isIphone = ->
    	@user_agent.indexOf('iphone') > -1
    @isIpod = ->
    	@user_agent.indexOf('ipod') > -1
    @isAndroid = ->
    	@user_agent.indexOf('android') > -1
    @isMobile = ->
    	@user_agent.indexOf('mobile') > -1

app = angular.module 'siteDealers',['ngAnimate','uiGmapgoogle-maps']
app.run()
.config ($interpolateProvider, uiGmapGoogleMapApiProvider)->
	$interpolateProvider.startSymbol('//-').endSymbol('-//')
	uiGmapGoogleMapApiProvider.configure
        #key: 'your api key',
        v: '3.17',
        libraries: 'weather,geometry,visualization'
.controller 'HomeController', ($location)->
	if $location.path()
		$(window).load ()->
			section = angular.element $location.path().replace('/','#')
			window.scrollTo 0, section.offset().top
.controller 'PortfolioController', ($scope, $http)->
	$scope.portfolioUrl = null
	$scope.showPortfolio = (e)->
		e.preventDefault()
		$scope.portfolioUrl = angular.element(e.currentTarget).attr('href')
		TweenLite.fromTo '.portfolio-meta', 1, {opacity: 0, x: -100}, {opacity: 1, x: 0, delay: 1}
	$scope.hidePortfolio = (e)->
		e.preventDefault()
		$scope.portfolioUrl = null
.controller 'ContactController', ($scope, uiGmapGoogleMapApi)->
	uiGmapGoogleMapApi.then (maps)->
		$scope.map = 
			center:
				latitude: 19.514705349999996
				longitude: -99.0405251
			zoom: 15
			marker:
				id: 0
				coords: 
					latitude: 19.516358739628966
					longitude: -99.04071821904904
				options:
					animation: 1
					#draggable: true
.factory 'utils', ()->
	_serialize = (obj)->
		str = []
		for p of obj
			if obj.hasOwnProperty p
	       		str.push encodeURIComponent(p) + "=" + encodeURIComponent(obj[p])
		str = str.join "&"
		str = '?'+str
	serialize: _serialize
.directive 'socialFb', ($http, $location, utils)->
	
	restrict: 'C'
	link: (scope, elem, attrs)->
		elem.on 'click', (e)->
			e.preventDefault()
			#$http.post 'https://www.googleapis.com/urlshortener/v1/url', {longUrl: $location.absUrl()}
			#.success (data)->
			request =
				app_id: '1532245233729879'
				u: $location.absUrl()#data.id
			query = utils.serialize request
			window.open attrs.href+query, 'Facebook', 'height=400, width=600'
.directive 'socialTw', ($http, $location, $document, utils)->
	restrict: 'C'
	link: (scope, elem, attrs)->
		elem.on 'click', (e)->
			e.preventDefault()
			#$http.post 'https://www.googleapis.com/urlshortener/v1/url', {longUrl: $location.absUrl()}
			#.success (data)->
			request =
					original_referer: $location.absUrl()
					text: $document[0].title
					url: $location.absUrl()#data.id
					via: 'BeDealers'
			query = utils.serialize request
			window.open attrs.href+query, 'Twitter', 'height=400, width=600'
.directive 'socialGp', ($http, $location, utils)->
	restrict: 'C'
	link: (scope, elem, attrs)->
		elem.on 'click', (e)->
			e.preventDefault()
			#$http.post 'https://www.googleapis.com/urlshortener/v1/url', {longUrl: $location.absUrl()}
			#.success (data)->
			request =
				url: $location.absUrl()#data.id
			query = utils.serialize request
			window.open attrs.href+query, 'Google Plus', 'height=400, width=600'
.directive 'socialIn', ($http, $location, utils)->
	restrict: 'C'
	link: (scope, elem, attrs)->
		elem.on 'click', (e)->
			request = 
				mini: true
				url: $location.absUrl()
				title: $document[0].title
				source: 'Digital Dealers'
			query = utils.serialize request
			window.open attrs.href+query, 'Linkedin', 'height=400, width=600'
.directive 'section', ($window, $document)->
	restrict: 'E'
	link: (scope, elem, attrs)->
		w = angular.element $window
		angular.element(document).ready ->
			elem.css 'min-height', $window.innerHeight+'px'
		w.on 'resize', (e)->
			elem.css 'min-height', $window.innerHeight+'px'

.directive 'mainMenu', ($window, $document, $interval, $location)->
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
				if not dealersjs.mobile.isMobile()
					tl.staggerFrom 'aside li', 1.2, {transformOrigin:"50% top", rotationX: -45, opacity: 0, ease: Elastic.easeOut}, 0.2
				else
					tl.staggerFrom 'aside li', 1.2, {opacity: 0, ease: Power2.easeOut}, 0.2
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
				tl.to window, 0.4, {scrollTo:{y: section.offset().top}, ease: Sine.easeOut, onComplete:()->
					$location.path anchor.attr('href').replace('#', '/')
				}
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

.directive 'portfolioPaginatorOption', ()->
	restrict: 'C'
	link: (scope, elem, attrs)->
		elem.on 'mouseenter', (e)->
			TweenLite.to elem, 0.4, {color: '#00b8bf', scale:1, ease: Power2.easeOut}
		elem.on 'mouseleave', (e)->
			TweenLite.to elem, 0.4, {color: '#ffffff', scale:1, ease: Power2.easeOut}
		elem.on 'click', (e)->
			TweenLite.to elem, 0.3, {scale: 0.8}
			angular.element('.portfolio-paginator-option').removeClass('active')
			elem.addClass('active')
			TweenLite.to elem, 0.3, {scale: 1, ease: Back.easeOut, delay: 0.3}

.directive 'portfolioList', ($compile)->
	restrict: 'C'
	link: (scope, elem, attrs)->
		scope.gotoPage = (pageNum)->
			startFrom = pageNum * pageItems
			endOn = startFrom + pageItems

			TweenMax.to scope.items, 0.3, {opacity: 0, ease: Power2.easeOut, onComplete:()->
				scope.items.addClass 'hide'	
				scope.items.slice(startFrom, endOn).removeClass('hide')
				TweenMax.set scope.items.slice(startFrom, endOn), {rotationX: -90}
				TweenMax.staggerTo scope.items.slice(startFrom, endOn), 1, {rotationX: 0, opacity:1, ease: Back.easeOut}, 0.1
			}
			scope.currentPage = pageNum
		
		pageItems = 12
		totalItems = 0
		totalPages = 0
		scope.currentPage = 0
		scope.items = elem.find 'li'
		totalItems = scope.items.size()
		totalPages = Math.ceil totalItems / pageItems
		scope.gotoPage scope.currentPage
		
		for num in [0...totalPages]
			angular.element('.portfolio-paginator').append($compile("<a class='portfolio-paginator-option' ng-click='gotoPage(#{num})'><i class='ion-ios-circle-filled'></i></a>")(scope))

		scope.items.each ()->
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