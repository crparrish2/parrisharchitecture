var relX;
var center;

function startup() {

     // Preload scroll bar
     imageObj = new Image();
     imageObj.src = 'http://www.parrish-architecture.com/images/sliderinvert.png';
 

    $('.scroll').each(
        function()
        {
            $(this).jScrollPane(
                {
                    horizontalDragMinWidth: 200,
                    horizontalDragMaxWidth: 200,
                    animateScroll: true
                }
            );
            var api = $(this).data('jsp');
            var throttleTimeout;
            $(window).bind(
                'resize',
                function()
                {
                    if ($.browser.msie) {
                        // IE fires multiple resize events while you are dragging the browser window which
                        // causes it to crash if you try to update the scrollpane on every one. So we need
                        // to throttle it to fire a maximum of once every 50 milliseconds...
                        if (!throttleTimeout) {
                            throttleTimeout = setTimeout(
                                function()
                                {
                                    api.reinitialise();
                                    throttleTimeout = null;
                                },
                                50
                            );
                        }
                    } else {
                        api.reinitialise();
                    }
                }
            );
        }
    )


    $(".portfolio-thumb").hover(

        function () {
            $(this).css({'opacity':0});
        },

        function () {
            $(this).css({'opacity':1});
        }
    );

    $('.jspDrag').effect("pulsate", { times:9 }, 1500, function(){
        $(this).css({'background':'#000000'});
    });

    $('.jspDrag').hover(
        function () {
            $(this).stop(true, true);
            $(this).css({'background':'red'});
            $(this).css({'background-image':'url(\'http://www.parrish-architecture.com/images/sliderinvert.png\')'});
            $(this).css({'opacity':1});
            
        },

        function () {
        	$(this).css({'background':'black'});
            $(this).css({'background-image':'url(\'http://www.parrish-architecture.com/images/sliderinvert.png\')'});
            $(this).css({'opacity':1});
        }
    );


//
//    setInterval(function(){
//        var pane = $(".scroll");
//        var api = pane.data('jsp');
//        api.scrollToX(api.getContentPositionX()+75, true);
//    }, 55);



//    $('.jspPane').each(function () {
//        var hovered = false;
//        var loop = window.setInterval(function () {
//            if (hovered) {
//                var pane = $(".scroll");
//                var api = pane.data('jsp');
//
//                if (Math.abs(relX - center) > 200){
//                    var hoverSize = center - 200;
//                    var speed = ((relX - center)/center)*500;
//                    api.scrollByX(speed);
//                }
//
//
//            }
//        }, 75);
//
//        $(this).hover(
//            function () {
//                hovered = true;
//            },
//            function () {
//                hovered = false;
//            }
//        );
//    });
//
//
//
//    $(".jspPane").mousemove(function(e){
//
//       // var offset = $(this).offset();
//        center = $(window).width()/2;
//
//        relX = e.pageX;
//
//        xPos = relX;
//    });


}