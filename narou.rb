require 'sinatra'
require 'json'
require 'net/http'


def gen_ncode
  return "n#{[*0..9999].sample.to_s.rjust(4,'0')}#{[*"a".."zz"].sample}"
end
get '/' do
  baseurl = "http://api.syosetu.com/novelapi/api/?out=json"
  ncodes = (1..100).map{gen_ncode}.join("-")
  res = Net::HTTP.get(URI.parse(baseurl + "&ncode=#{ncodes}"))
  @data = JSON.parse(res)
  print @data
  if @data[0]["allcount"].to_i == 0
    redirect "/" 
  end
  erb :index
end
