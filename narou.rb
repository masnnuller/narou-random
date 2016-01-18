require 'sinatra'
require 'json'
require 'net/http'


def gen_ncode
  return "n#{[*0..9999].sample.to_s.rjust(4,'0')}#{[*"a".."zz"].sample}"
end
get '/' do
  while true do
    baseurl = "http://api.syosetu.com/novelapi/api/?out=json"
    ncode = gen_ncode
    res = Net::HTTP.get(URI.parse(baseurl + "&ncode=#{ncode}"))
    data = JSON.parse(res)
    if data[0]["allcount"].to_i != 0
      redirect "http://ncode.syosetu.com/#{ncode}/"
    end
  end
end
