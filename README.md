# jekyll-extract-links
Gets all the links from your posts and adds them to the page.data for that post.

You can then use them in your liquid markup:

```liquid
<ul>
{% for link in page.links %}
  <li>{{ link.title }} {{ link.cleaner_href }} {{ link.href }}</li>
{% endfor %}
</ul>
```

The `title` is the text that appears inside the anchor tag and the `cleaner_href` is the `href` with [campaign utm](https://support.google.com/analytics/answer/1033863) and [Chrome text fragment](https://web.dev/text-fragments/) cruft removed, which can make a url human-unreadable.
