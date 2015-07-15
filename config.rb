require 'susy'
require 'slim'

# Actual deployment FQDN
set :deployment_url, 'http://example.com'

# Skip locale validation (and validation warnings)
I18n.enforce_available_locales = false

# Set TZ
Time.zone = "Moscow"

compass_config do |config|
  config.output_style = :compact
end

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes
# Pretty URLs
activate :directory_indexes
activate :syntax, :line_numbers => true
activate :autoprefixer

page "/feed.xml", layout: false

###
# Blog settings
###

# Time.zone = "UTC"
activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  blog.prefix = "blog"
  blog.permalink = "{year}/{month}/{day}/{title}.html"
  # blog.sources = "{year}-{month}-{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
  # blog.layout = "layout"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"
  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"
  # Enable pagination
  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end


###
# Helpers
###
helpers do
  # Calculate the years for a copyright
  def copyright_years(start_year)
    end_year = Date.today.year
    if start_year == end_year
      start_year.to_s
    else
      start_year.to_s + '-' + end_year.to_s
    end
  end

  # Holder.js image placeholder helper
  def img_holder(opts = {})
    return "Missing Image Dimension(s)" unless opts[:width] && opts[:height]
    return "Invalid Image Dimension(s)" unless opts[:width].to_s =~ /^\d+$/ && opts[:height].to_s =~ /^\d+$/

    img  = "<img data-src=\"holder.js/#{opts[:width]}x#{opts[:height]}/auto"
    img << "/#{opts[:bgcolor]}:#{opts[:fgcolor]}" if opts[:fgcolor] && opts[:bgcolor]
    img << "/text:#{opts[:text].gsub(/'/,"\'")}" if opts[:text]
    img << "\" width=\"#{opts[:width]}\" height=\"#{opts[:height]}\">"

    img
  end
end

set :css_dir, "css"
set :js_dir, "js"
set :images_dir, "img"
# set :fonts_dir,  "alternative_fonts_directory"

# Development configuration
configure :development do
  set :slim, pretty: true

# Reload the browser automatically whenever files change
activate :livereload

  set :debug_assets, true
end

# Build-specific configuration
configure :build do

  # Requires middleman-favicon-maker
  # activate :favicon_maker,
  #   :favicon_maker_base_image => "favicon_base.svg"

  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  # activate :cache_buster

  # Use relative URLs
  activate :relative_assets
  activate :asset_hash

  activete :gzip

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"

  activate :robots, :rules => [
    {
      :user_agent => '*',
      :allow => %w(/)
    }
  ],
  :sitemap => "#{deployment_url}/sitemap.xml"
end

activate :deploy do |deploy|
  deploy.method = :git
  # Optional Settings
  # deploy.remote   = 'custom-remote' # remote name or git url, default: origin
  # deploy.branch   = 'custom-branch' # default: gh-pages
  deploy.strategy = :submodule      # commit strategy: can be :force_push or :submodule, default: :force_push
  # deploy.commit_message = 'custom-message'      # commit message (can be empty), default: Automated commit at `timestamp` by middleman-deploy `version`
  deploy.build_before = true # default: false
end
