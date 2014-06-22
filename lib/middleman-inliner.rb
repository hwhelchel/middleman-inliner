require 'middleman-core'

class Inliner < Middleman::Extension
  def initialize(app, options_hash={}, &block)
    super

    app.compass_config do |config|
      config.output_style = :compressed
    end
  end

  helpers do
    def inline_css(*names)
      names.map { |name|
        name += ".css" unless name.include?(".css")
        css_path = sitemap.resources.select { |p| p.source_file.include?(name) }.first
        "<style type='text/css'>#{css_path.render}</style>"
      }.reduce(:+)
    end

    def inline_js(*names)
      names.map { |name|
        name += ".js" unless name.include?(".js")
        js = sprockets.find_asset(name).to_s
        "<script type='text/javascript'>#{defined?(Uglifier) ? Uglifier.compile(js) : js}</script>"
      }.reduce(:+)
    end

    alias :inline_javascripts :inline_js
    alias :inline_css_tag :inline_css
    alias :inline_js_tag :inline_js
    alias :inline_javascript_tag :inline_js
    alias :inline_stylesheet :inline_css
    alias :inline_stylesheet_tag :inline_css
  end
end

Inliner.register(:inliner)