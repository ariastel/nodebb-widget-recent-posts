'use strict';

const _ = require.main.require('lodash');
const nconf = require.main.require('nconf');
const categories = require.main.require('./src/categories');
const posts = require.main.require('./src/posts');
const SocketPlugins = require.main.require('./src/socket.io/plugins');
const utils = require.main.require('./src/utils');

let app;
const Widget = {};

Widget.init = async function (params) {
	app = params.app;
	handleSocketIO();
};

Widget.defineWidgets = async function (widgets) {
	return widgets.concat([
		{
			widget: 'aa_recentposts',
			name: 'Ariastel: Recent Posts',
			description: 'Displays a Recent posts.',
			content: await app.renderAsync('admin/aa_recentposts', {}),
		}
	]);
}

Widget.renderRecentPostsWidget = async function (widget) {

	let cid;
	if (widget.data.cid) {
		cid = widget.data.cid;
	} else if (widget.templateData.template.category) {
		cid = widget.templateData.cid;
	} else if (widget.templateData.template.topic && widget.templateData.category) {
		cid = widget.templateData.category.cid;
	}

	const numPosts = widget.data.numPosts || 4;
	const postsData = cid
		? await categories.getRecentReplies(cid, widget.uid, numPosts)
		: await posts.getRecentPosts(widget.uid, 0, Math.max(0, numPosts - 1), 'alltime');

	const data = {
		posts: postsData.filter(filterPost).map(handlePostContent),
		numPosts: numPosts,
		cid: cid,
		relative_path: nconf.get('relative_path'),
	};

	widget.html = await app.renderAsync('widgets/aa_recentposts', data);
	return widget;
};


function handleSocketIO() {
	SocketPlugins.AARecentPostsWidget = {};
	SocketPlugins.AARecentPostsWidget.getRecentPosts = async function (socket, posts) {

		const cids = _.uniq(posts.map(post => post.cid));
		const categoriesData = await categories.getCategoriesFields(cids, ['cid', 'name']);
		const categoryMap = _.keyBy(categoriesData, 'cid');

		for (const post of posts) {
			post.category = categoryMap[post.cid] ?? { cid: post.cid, name: '???' };
			post.teaser = getContentTeaser(post.content);
		}

		return posts;
	}
}

function filterPost(post) {
	return !post.isNSFW && !post.deleted;
}

function handlePostContent(post) {
	post.teaser = getContentTeaser(utils.stripHTMLTags(replaceImgWithAltText(post.content)));
	return post;
}

function replaceImgWithAltText(str) {
	return String(str).replace(/<img .*?alt="(.*?)"[^>]*>/gi, '$1');
}

function getContentTeaser(rawContent) {

	let result = rawContent.replace(/<br ?\/?>/g, '')

	const regexp = new RegExp(/<p dir="auto">((.|\n)*?)<\/p>/);
	if (regexp.test(rawContent)) {
		result = regexp.exec(result)[1];
	}

	return result.length > 77
		? result.slice(0, 77) + '...'
		: result;
}

module.exports = Widget;