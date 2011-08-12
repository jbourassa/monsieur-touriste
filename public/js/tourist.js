(function($){
	var Touriste = function(prev, next, cont){
		this.prev_btn = prev;
		this.next_btn = next;
		this.cont = cont;

		var pics = cont.find('li');

		this.nb_pics = pics.length;
		this.pic_width = pics.first().outerWidth();
	};

	Touriste.prototype = {
		init: function(){
			var t = this;
			this.prev_btn.click(function(e){
				e.preventDefault();
				t.move_prev();
			});
			this.next_btn.click(function(e){
				e.preventDefault();
				t.move_next();
			});
		},

		clear: function(){

		},

		move_next: function(){
			if(this.next_btn.hasClass('disabled')) return;
			this.move(-1);
		},

		move_prev: function(){
			if(this.prev_btn.hasClass('disabled')) return;
			this.move(1);
		},

		move: function(sign){
			//Cancel mad clicking
			if(this.cont.is(':animated')) return;
			
			//Compute next left value
			var px = (sign * this.pic_width) + parseInt(this.cont.css('left'));
			this.cont.animate({left: px + 'px'});

			//Update prev/next btn classes
			this.toggle_btn_class(px);
		},

		toggle_btn_class: function(target_left){
			if(target_left >= 0) this.prev_btn.addClass('disabled');
			else this.prev_btn.removeClass('disabled')
			if(target_left <= -1 * (this.nb_pics -1) * this.pic_width) this.next_btn.addClass('disabled');
			else this.next_btn.removeClass('disabled')
		}

	};

	$(function(){
		var pics = new Touriste($('#prev-pic'), $('#next-pic'), $('#tourist-pics'));
		pics.init();
		pics.toggle_btn_class(0);
	})
})(jQuery);
