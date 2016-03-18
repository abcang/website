(function() {
  'use strict';
  $(function() {
    $("a[href^='http']:not([href*='" + location.hostname + "'])").attr('target', '_blank');

    $('.children a').on('click', function(e) {
      var href = $(this).attr('href');
      if (href[0] === '#') {
        if ($('.navbar-toggle').attr('aria-expanded') == 'true') {
          $('.navbar-toggle').click();
        }
        $('html, body').animate({scrollTop: ($(href).offset().top - 10)}, 300);
        e.preventDefault();
      }
    });
  });
})();
