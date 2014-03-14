require 'rubygems'
require 'csv'
require 'json'
require 'net/http'


def scrape(username, tag)
  url = "http://www.delicious.com/v2/json/#{username}/#{tag}?count=1000"
  resp = Net::HTTP.get_response(URI.parse(url))
  data = resp.body

  # we convert the returned JSON data to native Ruby
  # data structure - a hash
  result = JSON.parse(data, :symbolize_names => true)

  #json = JSON.parse(data)
  #puts json.first.collect {|k,v| k}.join(',')
  #puts json.collect {|node| "#{node.collect{|k,v| v}.join(',')}\n"}.join

  CSV.open("#{username}-delicious.csv", "wb") do |csv|
    csv << ["URL", "Notes", "Tags", "Description"]
    result.each do |r|
      csv << ["#{r[:u]}", "#{r[:n]}", "#{r[:t]}", "#{r[:d]}"]
    end
  end
end

def get_tags(username)
  url = "http://feeds.delicious.com/v2/json/tags/#{username}?count=1000"
  resp = Net::HTTP.get_response(URI.parse(url))
  data = resp.body

  # we convert the returned JSON data to native Ruby
  # data structure - a hash
  result = JSON.parse(data, :symbolize_names => true)

  CSV.open("#{username}-delicious-tags.csv", "wb") do |csv|
    csv << ["tag", "count"]
    result.each do |r|
      csv << [r[0].to_s, r[1].to_s]
    end
  end
end
