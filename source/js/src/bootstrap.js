/* global NexT: true */

$(document).ready(function () {

  $(document).trigger('bootstrap:before');

    /**
   * Register JS handlers by condition option.
   * Need to add config option in Front-End at 'layout/_partials/head.swig' file.
   */
  CONFIG.fastclick && NexT.utils.isMobile() && window.FastClick.attach(document.body);
  CONFIG.lazyload && NexT.utils.lazyLoadPostsImages();

  NexT.utils.registerESCKeyEvent();

  NexT.utils.registerBackToTop();

  // Mobile top menu bar.
  $('.site-nav-toggle button').on('click', function () {
    var $siteNav = $('.site-nav');
    var ON_CLASS_NAME = 'site-nav-on';
    var isSiteNavOn = $siteNav.hasClass(ON_CLASS_NAME);
    var display = isSiteNavOn ? 'none' : 'block';
    var overflow = isSiteNavOn ? 'auto' : 'hidden';
    var navPos = isSiteNavOn ? '-100vw' : '0';
    var opacity = isSiteNavOn ? '0' : '1';
    var height = isSiteNavOn ? 'auto' : window.innerHeight + 'px';
    var animateAction = isSiteNavOn ? 'slideUp' : 'slideDown';
    var animateCallback = isSiteNavOn ? 'removeClass' : 'addClass';
    var $navDimmer = $('.nav-dimmer');
    var $overview = $('.site-overview-mobile');
    var $html = $('html');
    var $body = $('body');
    var $container = $('.container');

    if (!isSiteNavOn) {
      $overview.css({'display':display});
      $navDimmer[animateCallback]('nav-dimmer-on');
    }
    $siteNav.animate({left: navPos}, 600, function() {
      $siteNav[animateCallback](ON_CLASS_NAME);
      $overview.css({'display':display});
    });

    $navDimmer.animate({opacity: opacity}, 600, function() {
      $navDimmer[animateCallback]('nav-dimmer-on');
    });

    $html.css({'overflow':overflow});
    $body.css({'overflow':overflow});
    $container.css({'height':height});
  });

  window.onresize = function() {
    if (window.innerWidth > 991) {
      $('.site-nav').removeAttr('style');
    }
  }

  $('.nav-dimmer').on('click', function () {
    $('.site-nav-toggle button').trigger('click');
  });

  /**
   * Register JS handlers by condition option.
   * Need to add config option in Front-End at 'layout/_partials/head.swig' file.
   */
  CONFIG.fancybox && NexT.utils.wrapImageWithFancyBox();
  CONFIG.tabs && NexT.utils.registerTabsTag();

  NexT.utils.embeddedVideoTransformer();
  NexT.utils.addActiveClassToMenuItem();


  // Define Motion Sequence.
  NexT.motion.integrator
    .add(NexT.motion.middleWares.logo)
    .add(NexT.motion.middleWares.menu)
    .add(NexT.motion.middleWares.postList)
    .add(NexT.motion.middleWares.sidebar);

  $(document).trigger('motion:before');

  // Bootstrap Motion.
  CONFIG.motion.enable && NexT.motion.integrator.bootstrap();

  $(document).trigger('bootstrap:after');
});
