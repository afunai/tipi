require 'rubygems'
require 'net/http'
require 'rexml/document'
require 'sinatra'
require 'erubis'

get '/:username' do

  url = "http://api.twitpic.com/2/users/show.xml?username=#{params[:username]}"
  xml = Net::HTTP.get_response(URI.parse url).body
  doc = REXML::Document.new xml

  images = doc.elements.collect('user/images/image') do |image|
    {
      :short_id  => image.elements['short_id'].text,
      :message   => image.elements['message'].text,
      :timestamp => image.elements['timestamp'].text,
    }
  end

  erubis :carousel, :locals => {:images => images}

end
