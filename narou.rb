require 'sinatra'
require 'json'
require 'net/http'

def req(uri)
  return JSON.parse(
    Net::HTTP.get(uri)
  )
end

def get_data(fin,r18)
  baseurl = "http://api.syosetu.com/novelapi/api/?out=json"
  r18_url = "http://api.syosetu.com/novel18api/api/?out=json"
  params ||= ""
  res ||= []

  ncodes = (1..100).map{
    "n#{[*0..9999].sample.to_s.rjust(4,'0')}#{[*"a".."zz"].sample}"
  }.join("-")
  if fin
    params += "&stop=1"
  end
  res = req(URI.parse(baseurl + "&ncode=#{ncodes}" + params)).drop(1)
  if r18
    res += req(URI.parse(r18_url + "&ncode=#{ncodes}" + params)).drop(1)
  end
  return res.sample
end

get '/' do
  @checked ||= {}
  if params[:stop] == "true"
    fin = true
    @checked[:stop] = true
  end
  if params[:r18] == "true"
    r18 = true
    @checked[:r18] = true
  end
  fin ||= false
  r18 ||= false
  @data = get_data(fin=fin, r18=r18)
  if @data.nil?
    redirect "/" 
  end
  erb :index
end
