<!-- BEGIN posts -->
<li data-pid="{posts.pid}" class="aa_widget-post">
	<div class="aa_widget-post__header">
    <a href="<!-- IF posts.user.userslug -->{relative_path}/user/{posts.user.userslug}<!-- ELSE -->#<!-- ENDIF posts.user.userslug -->" class="aa_widget-post__author">

      <!-- IF posts.user.picture -->
      <img title="{posts.user.username}" class="avatar not-responsive" src="{posts.user.picture}" />
      <!-- ELSE -->
      <div title="{posts.user.username}" class="avatar not-responsive" style="background-color: {posts.user.icon:bgColor};">{posts.user.icon:text}</div>
      <!-- ENDIF posts.user.picture -->
    </a>
    <span class="aa_widget-post__time">
      <time class="timeago" datetime="{posts.timestampISO}" title="{posts.timestampISO}"></time>
    </span>
    <a href="{relative_path}/category/{posts.category.cid}" class="aa_widget-post__category">
      {posts.category.name}
    </a>
  </div>
  <a href="{relative_path}/post/{posts.pid}" class="aa_widget-post__teaser">
		{posts.teaser}
	</a>
</li>
<!-- END posts -->