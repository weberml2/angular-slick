'use strict'

angular.module('slick', [])
  .directive "slick", ($timeout) ->
    restrict: "AEC"
    scope:
      initOnload: "@"
      data: "="
      currentIndex: "="
      accessibility: "@"
      adaptiveHeight: "@"
      arrows: "@"
      asNavFor: "@"
      appendArrows: "@"
      appendDots: "@"
      autoplay: "@"
      autoplaySpeed: "@"
      centerMode: "@"
      centerPadding: "@"
      cssEase: "@"
      customPaging: "&"
      dots: "@"
      dotsClass: "@"
      draggable: "@"
      easing: "@"
      edgeFriction: "@"
      fade: "@"
      focusOnSelect: "@"
      infinite: "@"
      initialSlide: "@"
      lazyLoad: "@"
      mobileFirst: "@"
      onBeforeChange: "="
      onAfterChange: "="
      onInit: "="
      onReInit: "="
      onSetPosition: "="
      pauseOnHover: "@"
      pauseOnDotsHover: "@"
      responsive: "="
      respondTo: "@"
      rtl: "@"
      rows: "@"
      slidesPerRow: "@"
      slide: "@"
      slidesToShow: "@"
      slidesToScroll: "@"
      speed: "@"
      swipe: "@"
      swipeToSlide: "@"
      touchMove: "@"
      touchThreshold: "@"
      useCSS: "@"
      variableWidth: "@"
      vertical: "@"
      verticalSwiping: "@"
      waitForAnimate: "@"
      prevArrow:"@"
      nextArrow:"@"
      zIndex: "@"

    link: (scope, element, attrs) ->
      destroySlick = () ->
        $timeout(() ->
          slider = $(element)
          slider.slick('unslick')
          slider.find('.slick-list').remove()
          slider
        )
      initializeSlick = () ->
        $timeout(() ->
          slider = $(element)

          currentIndex = scope.currentIndex if scope.currentIndex?

          customPaging = (slick, index) ->
            scope.customPaging({ slick: slick, index: index })

          slider.slick
            accessibility: scope.accessibility isnt "false"
            adaptiveHeight: scope.adaptiveHeight is "true"
            arrows: scope.arrows isnt "false"
            asNavFor: if scope.asNavFor then scope.asNavFor else undefined
            appendArrows: if scope.appendArrows then $(scope.appendArrows) else $(element)
            appendDots: if scope.appendDots then $(scope.appendDots) else $(element)
            autoplay: scope.autoplay is "true"
            autoplaySpeed: if scope.autoplaySpeed? then parseInt(scope.autoplaySpeed, 10) else 3000
            centerMode: scope.centerMode is "true"
            centerPadding: scope.centerPadding or "50px"
            cssEase: scope.cssEase or "ease"
            customPaging: if attrs.customPaging then customPaging else undefined
            dots: scope.dots is "true"
            dotsClass: scope.dotsClass or "slick-dots" 
            draggable: scope.draggable isnt "false"
            easing: scope.easing or "linear"
            edgeFriction: scope.edgeFriction or 0.15
            fade: scope.fade is "true"
            focusOnSelect: scope.focusOnSelect is "true"
            infinite: scope.infinite isnt "false"
            initialSlide:scope.initialSlide or 0
            lazyLoad: scope.lazyLoad or "ondemand"
            mobileFirst: scope.mobileFirst is "true"
            pauseOnHover: scope.pauseOnHover isnt "false"
            pauseOnDotsHover: scope.pauseOnDotsHover is "true"
            responsive: scope.responsive or undefined
            rtl: scope.rtl is "true"
            respondTo: if scope.respondTo? then scope.respondTo else "window"
            rows: if scope.rows? then parseInt(scope.rows, 10) else 1
            slidesPerRow: if scope.slidesPerRow? then parseInt(scope.slidesPerRow, 10) else 1
            slide: scope.slide or "div"
            slidesToShow: if scope.slidesToShow? then parseInt(scope.slidesToShow, 10) else 1
            slidesToScroll: if scope.slidesToScroll? then parseInt(scope.slidesToScroll, 10) else 1
            speed: if scope.speed? then parseInt(scope.speed, 10) else 300
            swipe: scope.swipe isnt "false"
            swipeToSlide: scope.swipeToSlide is "true"
            touchMove: scope.touchMove isnt "false"
            touchThreshold: if scope.touchThreshold then parseInt(scope.touchThreshold, 10) else 5
            useCSS: scope.useCSS isnt "false"
            variableWidth: scope.variableWidth is "true"
            vertical: scope.vertical is "true"
            verticalSwiping: scope.verticalSwiping? is "true"
            waitForAnimate: scope.waitForAnimate? isnt "true"
            zIndex: if scope.zIndex? then parseInt(scope.zIndex, 10) else 1000
            prevArrow: if scope.prevArrow then $(scope.prevArrow) else undefined
            nextArrow: if scope.nextArrow then $(scope.nextArrow) else undefined


          slider.on 'init', (event, slick) ->
            scope.onInit() if attrs.onInit
            if currentIndex?
              slick.slideHandler(currentIndex)

          slider.on 'reInit', (event, slick) ->
            scope.onReInit() if attrs.onReInit

          slider.on 'setPosition', (event, slick) ->
            scope.onSetPosition() if attrs.onSetPosition

          slider.on 'swipe', (event, slick, direction) ->
            scope.onSwipe(direction) if attrs.onSwipe

          slider.on 'afterChange', (event, slick, currentSlide) ->
            scope.onAfterChange(currentSlide) if scope.onAfterChange

            if currentIndex?
              scope.$apply(->
                currentIndex = currentSlide
                scope.currentIndex = currentSlide
              )

          slider.on 'beforeChange', (event, slick, currentSlide, nextSlide) ->
            scope.onBeforeChange(currentSlide, nextSlide) if attrs.onBeforeChange

          slider.on 'breakpoint', (event, slick) ->
            scope.onBreakpoint() if attrs.onBreakpoint

          slider.on 'destroy', (event, slick) ->
            scope.onDestroy() if attrs.onDestroy

          slider.on 'edge', (event, slick, direction) ->
            scope.onEdge(direction) if attrs.onEdge

          scope.$watch("currentIndex", (newVal, oldVal) ->
            if currentIndex? and newVal? and newVal != currentIndex
              slider.slick('slickGoTo', newVal)
          )
        )

      if scope.initOnload
        isInitialized = false
        scope.$watch("data", (newVal, oldVal) ->
          if newVal?
            if isInitialized
              destroySlick()

            initializeSlick()
            isInitialized = true
        )
      else
        initializeSlick()
