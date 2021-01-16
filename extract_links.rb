# Gets all the links from each post and adds them to the page.data for that post
# so you can extract them with some liquid markup like:
#
#   {% for link in page.links %}
#       <br>{{ link.title }} {{ link.cleaner_href }} {{ link.href }}
#   {% endfor %}
#
# The cleaner_href is the href with campaign utm and Chrome deep text links cruft
# removed, which can make a url human-unreadable

require "nokogiri"

class ExtractedLinksGenerator < Jekyll::Generator
  def generate(site)
    parser = Jekyll::Converters::Markdown.new(site.config)

    site.documents.each do |page|
      doc = Nokogiri::HTML(parser.convert(page.content))
      page.data["links"] = []
      doc.css("a").each do |anchor|
        text_fragment_regex = /#:~:text=.*/
        utm_regex = /&?utm_.+?(&|$)/

        title = anchor.children.first.text
        href = anchor[:href]
        cleaner_href = href

        # Strip deep text link
        cleaner_href = href.gsub(text_fragment_regex, "") if href.match(text_fragment_regex)

        # Strip analytics cruft
        cleaner_href = href.gsub(utm_regex, "") if href.match(utm_regex)

        # Add it to the page's data
        page.data["links"] << {
          "title" => title,
          "cleaner_href" => cleaner_href,
          "href" =>  href,
        } unless page.data["links"].map {|links| links["href"]}.include?(href)
      end

    end
  end
end
