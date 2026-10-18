# Generates a landing page for every entry in the scholar bibliography at
# /publications/<title-slug>-<year>/ using _layouts/paper.html.
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

      arxiv = clean(entry[:arxiv])
      pdf_rel, pdf_abs = resolve(site, clean(entry[:pdf]))
      pdf_rel, pdf_abs = ["https://arxiv.org/pdf/#{arxiv}"] * 2 if pdf_abs.nil? && arxiv

      links = []
      add = ->(label, url) { links << { 'label' => label, 'url' => url } if url }
      add.call('arXiv', arxiv && "https://arxiv.org/abs/#{arxiv}")
      add.call('HTML', clean(entry[:html]))
      add.call('Data', clean(entry[:data]))
      add.call('PDF', pdf_rel)
      add.call('Supp', resolve(site, clean(entry[:supp])).first)
      add.call('Blog', clean(entry[:blog]))
      add.call('Code', clean(entry[:code]))
      add.call('Poster', resolve(site, clean(entry[:poster])).first)
      add.call('Slides', resolve(site, clean(entry[:slides])).first)
      add.call('Website', clean(entry[:website]))

      abstract = clean(entry[:abstract])
      description = abstract || title
      description = description[0, 297].sub(/\s+\S*\z/, '') + '...' if description.length > 300
      description = description.tr('"', "'")

      preview = clean(entry[:preview])
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
        'doi' => clean(entry[:doi]),
        'arxiv' => arxiv,
        'pdf' => pdf_abs,
        'html' => clean(entry[:html]) || clean(entry[:url]),
        'keywords' => clean(entry[:keywords]),
        'note' => entry[:note]&.to_s,
        'links' => links,
        'preview' => preview_abs,
        'bibtex' => entry[:bibtex_show] ? entry.to_s : nil,
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
end
