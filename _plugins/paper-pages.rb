# Generates a landing page for every entry in the scholar bibliography at
# /publications/<title-slug>-<year>/ using _layouts/paper.html.
#
# After the site is written it also creates plain-text files for AI agents:
#   /llms.txt                          - index of the site (https://llmstxt.org)
#   /llms-full.txt                     - every paper with abstract, links and citation
#   /publications/<slug>/index.md      - Markdown version of each paper page
#
# Exposes to Liquid:
#   site.data.paper_pages      - { bib key => slug }, used by _layouts/bib.html to link titles
#   site.data.paper_pages_list - list of paper hashes (newest first), used for "Other publications"
#   page.paper                 - the paper hash on each generated page; _includes/metadata.html
#                                renders Google Scholar citation_* tags and Schema.org JSON-LD from it

require 'bibtex'
begin
  require 'latex/decode'
rescue LoadError
end

module Jekyll
  module PaperPages
    MONTHS = %w[jan feb mar apr may jun jul aug sep oct nov dec].freeze
    SLUG_MAX_WORDS = 10
    SLUG_TRAILING_STOPWORDS = %w[a an the of for on in and to with during based].freeze

    module_function

    def clean(value)
      return nil if value.nil?
      s = value.to_s.dup
      if defined?(LaTeX) && LaTeX.respond_to?(:decode)
        s = (LaTeX.decode(s) rescue s)
      end
      s = s.gsub(/\\&/, '&').gsub(/[{}]/, '').gsub(/\s+/, ' ').strip
      s.empty? ? nil : s
    end

    # For URLs and file paths: no LaTeX decoding (it would turn "~" into a space).
    def plain(value)
      return nil if value.nil?
      s = value.to_s.strip
      s.empty? ? nil : s
    end

    def slugify(title, year)
      words = title.downcase.gsub(/[^a-z0-9]+/, ' ').split.first(SLUG_MAX_WORDS)
      words.pop while words.size > 1 && SLUG_TRAILING_STOPWORDS.include?(words.last)
      [*words, year].compact.join('-')
    end

    # Returns [site-relative url for links, absolute url for metadata].
    def resolve(site, path)
      return [nil, nil] if path.nil?
      return [path, path] if path.include?('://')
      rel = "#{site.config['baseurl']}/assets/pdf/#{path}".gsub(' ', '%20')
      [rel, "#{site.config['url']}#{rel}"]
    end

    def month_number(month)
      return nil if month.nil?
      idx = MONTHS.index(month.downcase[0, 3])
      return idx + 1 if idx
      n = month.to_i
      n.between?(1, 12) ? n : nil
    end

    def build(site, entry)
      title = clean(entry[:title])
      return nil unless title

      year = clean(entry[:year])
      month = month_number(clean(entry[:month]))
      self_last = Array(site.config.dig('scholar', 'last_name'))

      authors = []
      if entry[:author].respond_to?(:each)
        entry[:author].each do |name|
          first = clean(name.first)
          last = clean([name.von, name.last].compact.join(' '))
          authors << {
            'first' => first,
            'last' => last,
            'full' => [first, last].compact.join(' '),
            'citation' => [last, first].compact.join(', '),
            'is_self' => self_last.include?(last)
          }
        end
      end

      pages = clean(entry[:pages])
      first_page, last_page = pages ? pages.split(/\s*[-–—]+\s*/, 2) : [nil, nil]

      arxiv = plain(entry[:arxiv])
      pdf_rel, pdf_abs = resolve(site, plain(entry[:pdf]))
      pdf_rel, pdf_abs = ["https://arxiv.org/pdf/#{arxiv}"] * 2 if pdf_abs.nil? && arxiv

      links = []
      add = ->(label, url) { links << { 'label' => label, 'url' => url } if url }
      add.call('arXiv', arxiv && "https://arxiv.org/abs/#{arxiv}")
      add.call('HTML', plain(entry[:html]))
      add.call('Data', plain(entry[:data]))
      add.call('PDF', pdf_rel)
      add.call('Supp', resolve(site, plain(entry[:supp])).first)
      add.call('Blog', plain(entry[:blog]))
      add.call('Code', plain(entry[:code]))
      add.call('Poster', resolve(site, plain(entry[:poster])).first)
      add.call('Slides', resolve(site, plain(entry[:slides])).first)
      add.call('Website', plain(entry[:website]))

      abstract = clean(entry[:abstract])
      description = abstract || title
      description = description[0, 297].sub(/\s+\S*\z/, '') + '...' if description.length > 300
      description = description.tr('"', "'")

      preview = plain(entry[:preview])
      preview_abs = if preview.nil? then nil
                    elsif preview.include?('://') then preview
                    else "#{site.config['url']}#{site.config['baseurl']}/assets/img/publication_preview/#{preview}"
                    end

      {
        'key' => entry.key.to_s,
        'type' => entry.type.to_s.downcase,
        'title' => title,
        'authors' => authors,
        'year' => year,
        'date' => month && year ? format('%s/%02d', year, month) : year,
        'abstract' => abstract,
        'description' => description,
        'venue' => clean(entry[:booktitle]) || clean(entry[:journal]),
        'venue_short' => clean(entry[:abbr]),
        'volume' => clean(entry[:volume]),
        'issue' => clean(entry[:number]),
        'first_page' => first_page,
        'last_page' => last_page,
        'publisher' => clean(entry[:publisher]),
        'isbn' => clean(entry[:isbn]),
        'doi' => plain(entry[:doi]),
        'arxiv' => arxiv,
        'pdf' => pdf_abs,
        'html' => plain(entry[:html]) || plain(entry[:url]),
        'keywords' => clean(entry[:keywords]),
        'note' => entry[:note]&.to_s,
        'links' => links,
        'preview' => preview_abs,
        'bibtex' => entry[:bibtex_show] ? entry.to_s.gsub(/^\s*month_numeric\s*=.*\n/, '') : nil,
        'slug' => slugify(title, year)
      }
    end
  end

  class PaperPagesGenerator < Generator
    safe true
    priority :low

    def generate(site)
      scholar = site.config['scholar'] || {}
      source = (scholar['source'] || '_bibliography').sub(%r{\A/}, '')
      path = File.join(site.source, source, scholar['bibliography'] || 'papers.bib')
      return unless File.exist?(path)

      raw = File.read(path).sub(/\A---\s*\n.*?---\s*\n/m, '')
      papers = BibTeX.parse(raw).each_entry.map { |e| PaperPages.build(site, e) }.compact
      papers = papers.each_with_index.sort_by { |p, i| [-p['year'].to_i, i] }.map(&:first)

      seen = Hash.new(0)
      papers.each do |p|
        seen[p['slug']] += 1
        p['slug'] = "#{p['slug']}-#{seen[p['slug']]}" if seen[p['slug']] > 1
        p['url'] = "/publications/#{p['slug']}/"
      end

      site.data['paper_pages'] = papers.to_h { |p| [p['key'], p['slug']] }
      site.data['paper_pages_list'] = papers

      papers.each do |p|
        page = PageWithoutAFile.new(site, site.source, File.join('publications', p['slug']), 'index.html')
        page.content = ''
        page.data.merge!(
          'layout' => 'paper',
          'title' => p['title'],
          'description' => p['description'],
          'keywords' => p['keywords'],
          'og_image' => p['preview'],
          'paper' => p
        )
        site.pages << page
      end
    end
  end

  # Plain-text files for AI agents. Written straight to the destination after the build so that
  # Jekyll does not convert the Markdown to HTML and the files stay out of the sitemap.
  module LlmsFiles
    module_function

    def root(site)
      "#{site.config['url']}#{site.config['baseurl']}"
    end

    def absolute(site, url)
      url.start_with?('/') ? "#{site.config['url']}#{url}" : url
    end

    def name(site)
      [site.config['first_name'], site.config['middle_name'], site.config['last_name']].compact.join(' ').squeeze(' ').strip
    end

    def intro(site)
      site.config['llms_intro'].to_s.strip
    end

    # Converts the HTML links allowed in bib `note` fields to Markdown.
    def html_to_markdown(site, html)
      html.gsub(%r{<a\s+href="([^"]+)"[^>]*>(.*?)</a>}m) { "[#{Regexp.last_match(2)}](#{absolute(site, Regexp.last_match(1))})" }
          .gsub(/<[^>]+>/, '').strip
    end

    def citation(site, bibtex)
      Array(site.config['filtered_bibtex_keywords']).reduce(bibtex) do |text, keyword|
        text.gsub(/^.*\b#{keyword}\b *= *\{.*$\n/, '')
      end
    end

    def venue_line(p)
      venue = p['venue']
      venue = "#{venue} (#{p['venue_short']})" if venue && p['venue_short']
      venue ||= p['venue_short']
      [venue, p['year']].compact.join(', ')
    end

    def paper_markdown(site, p, level = 1)
      h = '#' * level
      out = ["#{h} #{p['title']}", '']
      out << "- **Authors:** #{p['authors'].map { |a| a['full'] }.join(', ')}"
      out << "- **Venue:** #{venue_line(p)}" unless venue_line(p).empty?
      out << "- **Publisher:** #{p['publisher']}" if p['publisher']
      out << "- **DOI:** https://doi.org/#{p['doi']}" if p['doi']
      out << "- **Keywords:** #{p['keywords']}" if p['keywords']
      out << "- **Page:** #{root(site)}#{p['url']}"
      out << "- **Note:** #{html_to_markdown(site, p['note'])}" if p['note']
      if p['abstract']
        out += ['', "#{h}# Abstract", '', p['abstract']]
      end
      unless p['links'].empty?
        out += ['', "#{h}# Links", '']
        p['links'].each { |l| out << "- #{l['label']}: #{absolute(site, l['url'])}" }
      end
      if p['bibtex']
        out += ['', "#{h}# Citation", '', '```bibtex', citation(site, p['bibtex']).strip, '```']
      end
      out.join("\n") + "\n"
    end

    def profiles(site)
      links = []
      links << "https://scholar.google.com/citations?user=#{site.config['scholar_userid']}" if site.config['scholar_userid']
      links += Array(site.config['schema_same_as'])
      links << "https://github.com/#{site.config['github_username']}" if site.config['github_username']
      links << "https://www.linkedin.com/in/#{site.config['linkedin_username']}" if site.config['linkedin_username']
      links
    end

    def page_link(site, url, label)
      page = site.pages.find { |pg| pg.url == url }
      return nil unless page
      desc = page.data['description'].to_s.strip
      "- [#{label}](#{root(site)}#{url})#{desc.empty? ? '' : ": #{desc}"}"
    end

    def llms_txt(site, papers)
      out = ["# #{name(site)}", '', "> #{intro(site)}", '']
      out << 'Each publication has an HTML page and a Markdown version (append `index.md` to the page URL). ' \
             "Full details of all publications are in #{root(site)}/llms-full.txt."
      out += ['', '## Publications', '']
      papers.each do |p|
        authors = p['authors'].map { |a| a['full'] }.join(', ')
        out << "- [#{p['title']}](#{root(site)}#{p['url']}index.md): #{[p['venue_short'] || p['venue'], p['year']].compact.join(', ')}. #{authors}."
      end
      out += ['', '## About', '']
      out << "- [Home](#{root(site)}/): #{site.config['description'].to_s.strip}"
      [['/cv/', 'CV'], ['/talks/', 'Talks'], ['/teaching/', 'Teaching'], ['/collaborating/', 'Collaborating']].each do |url, label|
        line = page_link(site, url, label)
        out << line if line
      end
      posts = site.posts.docs.sort_by { |d| d.date }.reverse
      unless posts.empty?
        out += ['', '## Blog posts', '']
        posts.each { |d| out << "- [#{d.data['title']}](#{d.data['redirect'] || absolute(site, d.url)})" }
      end
      out += ['', '## Profiles', '']
      profiles(site).each { |l| out << "- #{l}" }
      out += ['', '## Optional', '']
      out << "- [Full publication details](#{root(site)}/llms-full.txt): all papers with authors, venues, abstracts, links and BibTeX"
      out.join("\n") + "\n"
    end

    def llms_full_txt(site, papers)
      out = ["# #{name(site)}: publications", '', "> #{intro(site)}", '']
      out << "Website: #{root(site)}/"
      out << "Profiles: #{profiles(site).join(', ')}"
      out << ''
      papers.each { |p| out << '---' << '' << paper_markdown(site, p, 2) }
      out.join("\n")
    end

    def write(site)
      papers = site.data['paper_pages_list']
      return if papers.nil? || papers.empty?

      File.write(File.join(site.dest, 'llms.txt'), llms_txt(site, papers))
      File.write(File.join(site.dest, 'llms-full.txt'), llms_full_txt(site, papers))
      papers.each do |p|
        dir = File.join(site.dest, p['url'])
        FileUtils.mkdir_p(dir)
        File.write(File.join(dir, 'index.md'), paper_markdown(site, p))
      end
    end
  end
end

Jekyll::Hooks.register :site, :post_write do |site|
  Jekyll::LlmsFiles.write(site)
end
