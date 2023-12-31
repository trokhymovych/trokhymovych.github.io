require 'feedjira'
require 'httparty'
require 'jekyll'
require 'nokogiri'

module ExternalPosts
  class ExternalPostsGenerator < Jekyll::Generator
    safe true
    priority :high

    def generate(site)
      if site.config['external_sources'] != nil
        site.config['external_sources'].each do |src|
          p "Fetching external posts from #{src['name']}:"
          xml = HTTParty.get(src['rss_url']).body
          feed = Feedjira.parse(xml)
          feed.entries.each do |e|
            p "...fetching #{e.url}"
            slug = e.title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
            path = site.in_source_dir("_posts/#{slug}.md")
            doc = Jekyll::Document.new(
              path, { :site => site, :collection => site.collections['posts'] }
            )
            doc.data['external_source'] = src['name'];
            doc.data['feed_content'] = e.content;
            doc.data['title'] = "#{e.title}";
            doc.data['description'] = e.summary;
            doc.data['date'] = e.published;
            doc.data['redirect'] = e.url;

            # Extract the first image link using Nokogiri
            html_content = Nokogiri::HTML(e.content)
            first_image = html_content.at_css('img')
            if first_image
              doc.data['thumbnail'] = first_image['src']
            end
            site.collections['posts'].docs << doc
          end
        end
      end
    end
  end

end
