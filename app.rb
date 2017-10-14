require 'open-uri'
require 'nokogiri'
require 'sinatra'

get '/' do
  erb :'home'
end

get '/search' do
  @cards = []

  search_url = "https://www.deviantart.com/?section=&global=1&q=#{params[:query]}" #url de la recherche avec mot clef en ruby

  html_file = open(search_url)   #ouvre dans un fichier html
  html_document = Nokogiri::HTML(html_file)  #traduit la source

  #css trouvé en examinant la page de recherche dribble

  collection_css_path = 'span.thumb' # <= customize (classe de la carte dribble)
  collection = html_document.css(collection_css_path)

  collection.each do |element|  #element est un li group each permet de faire l'opération pour toute la liste
    #title
    title_css_path = '.thumb .info .title-wrap .title' # <= customize
    title = element.css(title_css_path).text

    # skip if it's not a real card
    unless title.empty?
      # url
      relative_url_css_path = '.thumb a.torpedo-thumb-link' # <= customize
      absolute_url = element.css(relative_url_css_path).attr('href')   #pour trouver le lien dans href
      # or
      # absolute_url = "https://dribbble.com/" + relative_url

      # image
      image_url_css_path = '.thumb a.torpedo-thumb-link img' # <= customize
      image_url = element.css(image_url_css_path).attr('src')

      @cards << [title, absolute_url, image_url]  # tableau dans lequel on mets les éléments récupérés : titre, url et image
    end
  end

  erb :'search'
end
