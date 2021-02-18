<div class="aa_recent-replies">
	<ul id="aa_recent_posts" data-numposts="{numPosts}" data-cid="{cid}">
		<!-- IMPORT partials/posts.tpl -->
	</ul>
	<a href="{relative_path}/recent" class="aa_recent_posts">[[recent-posts:more]]>></a>
</div>

<script>
	'use strict';
	/* globals app, socket*/
	(function () {
		function onLoad() {

			var replies = $('#aa_recent_posts');
			var numPosts = parseInt(replies.attr('data-numposts'), 10) || 4;

			var aa_recentPostsWidget = app.widgets.aa_recentPosts;
			if (!aa_recentPostsWidget) {
				aa_recentPostsWidget = {};

				aa_recentPostsWidget.onNewPost = function (data) {
					var cid = replies.attr('data-cid');

					var recentPosts = $('#aa_recent_posts');
					if (!recentPosts.length) {
						return;
					}

					if (cid && parseInt(cid, 10) !== parseInt(data.posts[0].topic.cid, 10)) {
						return;
					}

					socket.emit('plugins.AARecentPostsWidget.getRecentPosts', data.posts, function (err, postsUpd) {
						console.log(postsUpd);
						app.parseAndTranslate('partials/posts', {
							relative_path: config.relative_path,
							posts: postsUpd
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
					});
				};

				app.widgets.aa_recentPosts = aa_recentPostsWidget;
				socket.on('event:new_post', app.widgets.aa_recentPosts.onNewPost);
			}

			function processHtml(html) {
				if ($.timeago) {
					console.log(html.find('.timeago'))
					html.find('.timeago').timeago();
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