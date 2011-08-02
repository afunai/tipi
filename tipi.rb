require 'rubygems'
require 'net/http'
require 'rexml/document'
require 'sinatra'
require 'erubis'

get '/:username' do

  url = "http://api.twitpic.com/2/users/show.xml?username=#{params[:username]}"
  xml = Net::HTTP.get_response(URI.parse url).body
  doc = REXML::Document.new xml

  user = {
    :username   => doc.elements['user/username'].text,
    :avatar_url => doc.elements['user/avatar_url'].text,
  }

  images = doc.elements.collect('user/images/image') do |image|
    {
      :short_id  => image.elements['short_id'].text,
      :message   => image.elements['message'].text.gsub(/\s/, ' '),
      :timestamp => image.elements['timestamp'].text,
    }
  end

  erubis :carousel, :locals => {:user => user, :images => images}

end
