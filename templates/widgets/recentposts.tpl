<div class="aa_recent-replies">
	<ul id="aa_recent_posts" data-numposts="{numPosts}" data-cid="{cid}">
		<!-- IMPORT partials/posts.tpl -->
	</ul>
	<a href="{relative_path}/recent" class="aa_recent_posts">Смотреть еще>></a>
</div>

<script>
	'use strict';
	/* globals app, socket*/
	(function () {
		function onLoad() {
			var replies = $('#aa_recent_posts');
			var recentPostsWidget = app.widgets.recentPosts;
			var numPosts = parseInt(replies.attr('data-numposts'), 10) || 4;
			if (!recentPostsWidget) {
				recentPostsWidget = {};
				recentPostsWidget.onNewPost = function (data) {
					var cid = replies.attr('data-cid');
					var recentPosts = $('#aa_recent_posts');
					if (!recentPosts.length) {
						return;
					}
					if (cid && parseInt(cid, 10) !== parseInt(data.posts[0].topic.cid, 10)) {
						return;
					}
					app.parseAndTranslate('partials/posts', {
						relative_path: config.relative_path,
						posts: data.posts
					}, function (html) {
						processHtml(html);
						html.hide()
							.prependTo(recentPosts)
							.fadeIn();
						app.createUserTooltips();
						if (recentPosts.children().length > numPosts) {
							recentPosts.children().last().remove();
						}
					});
				};
				app.widgets.recentPosts = recentPostsWidget;
				socket.on('event:new_post', app.widgets.recentPosts.onNewPost);
			}
			function processHtml(html) {
				if ($.timeago) {
					html.find('span.timeago').timeago();
				}
			}
		}

		if (window.jQuery) {
			onLoad();
		} else {
			window.addEventListener('DOMContentLoaded', onLoad);
		}
	})();
</script>