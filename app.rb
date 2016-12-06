require "sinatra"
require "sinatra/base"
require 'sinatra/contrib'
require 'active_support/all'
require "active_support/core_ext"
require 'json'
require 'sinatra/activerecord'
require 'haml'
require 'builder'

require_relative './models/courselink'
require_relative './models/week'

set :database, "sqlite3:db/my_database.db"


enable :sessions


configure do
  set :slack, "http://onlineprototypes2016.slack.com/"
  set :site, 'https://daraghbyrne.github.io/onlineprototypes2016/'
  set :repo, 'https://github.com/daraghbyrne/onlineprototypes2016repo'
 
  set :class_time_tuesday_start, Time.new( 2016, 10, 25, 12, 00 )
  set :class_time_tuesday_end, Time.new( 2016, 10, 25, 14, 50 )
  set :office_hours_start, Time.new(2016, 10, 27, 12, 00)
  set :office_hours_end, Time.new(2016, 10, 27,  14, 00)
=begin  
  set :links, ["https://medium.com/ideo-stories/chatbots-ultimate-prototyping-tool-e4e2831967f3#.3pif99l08", "http://www.bloomberg.com/news/articles/2015-09-17/who-needs-an-interface-anyway-", "https://digit.co", "https://getmagic.com", "https://hirepeter.com", "http://callfrank.org", "https://twitter.com/slashgif", "http://pentametron.com", "https://twitter.com/NYTMinusContext", "https://slack.getbirdly.com", "https://developer.amazon.com/alexa", "https://www.producthunt.com/@rrhoover/collections/invisible-apps"]
=end 
end
get '/reset_views' do
	reset_views
end

get '/courselinks' do
	Courselink.all.to_json
end

get '/courselinks/:id' do
	Courselink.where(id: params['id']).to_json
end

post '/courselinks' do
   link = Courselink.new(params)

  if link.save
    link.to_json
  else
    halt 422, link.errors.full_messages.to_json
  end
end

put '/courselinks/:id' do
  link = Courselink.where(id: params['id']).first

  if link
    link.url = params['url'] if params.has_key?('url')
    link.title = params['title'] if params.has_key?('title')
    link.week_id = params['week_id'] if params.has_key?('week_id')
    if link.save
      link.to_json
    else
      halt 422, task.errors.full_messages.to_json
    end
  end
end

delete '/courselinks/:id' do

  link = Courselink.where(id: params['id'])

  if link.destroy_all
    {success: "ok"}.to_json
  else
    halt 500
  end
end

get '/weeks' do
	Week.all.to_json
end

get '/weeks/:id' do
	Week.where(id: params['id']).to_json
end

post '/weeks' do
  link = Week.new(params)

  if weeks.save
    weeks.to_json
  else
    halt 422, link.errors.full_messages.to_json
  end
end

put '/weeks/:id' do
  link = Week.where(id: params['id']).first

  if link
    link.topic = params['topic'] if params.has_key?('topic')
    link.beginning = params['beginning'] if params.has_key?('beginning')

    if link.save
      link.to_json
    else
      halt 422, link.errors.full_messages.to_json
    end
  end
end

delete '/weeks/:id' do
  link = Week.where(id: params['id'])

  if link.destroy_all
    {success: "ok"}.to_json
  else
    halt 500
  end
end

put '/courselinks/:id' do
	link = Courselink.where(week_id: params['id']).first
	if link
    link.url = params['url'] if params.has_key?('url')
    link.title = params['title'] if params.has_key?('title')
    link.week_id = params['week_id'] if params.has_key?('week_id')
    if link.save
      link.to_json
    else
      halt 422, task.errors.full_messages.to_json
    end
	end

  end
	
get '/assignments' do
	Assignment.all.to_json
end

get '/assignments/:id' do
	Assignment.where(id: params['id']).to_json
end

post '/assignments' do
  link = Assignment.new(params)

  if assignments.save
    assignments.to_json
  else
    halt 422, link.errors.full_messages.to_json
  end
end

put '/assignments/:id' do
  link = Assignment.where(id: params['id']).first

  if link
    link.description = params['description'] if params.has_key?('description')
	link.week_id = params['week_id'] if params.has_key?('week_id')
	link.url = params['url'] if params.has_key?('url')
	link.due_date = params['due_date'] if params.has_key?('due_date')
	
    if link.save
      link.to_json
    else
      halt 422, task.errors.full_messages.to_json
    end
  end
end

delete '/assignments/:id' do
  link = Assignment.where(id: params['id'])

  if link.destroy_all
    {success: "ok"}.to_json
  else
    halt 500
  end
end


get "/in_session" do

	session_start_time = Time.new( 2016, 11, 1, 12, 00 )
  session_end_time = session_start_time + 2.hour + 50.minutes
  
  is_in_session = false
  time_now = Time.now

  
  (1..8).each do |i|
  
    if time_now >= session_start_time and time_now <= session_end_time 
      is_in_session = true
    end

    session_start_time = session_start_time + 7.days
    session_end_time = session_end_time + 7.days
    
  end
  
  if is_in_session == true
      "Yes"
  else
      "No"
  end
  
  { now: time_now, in_session: is_in_session, in_session_string: ( is_in_session ? "YES" : "NO" ) }.to_json
  
end

get "/" do
	401
end
 

get "/title" do
	{title: "Programming for Online Prototypes"}.to_json
end

get "/catalog_description" do
  "An introduction to rapidly prototyping web-based products and services. This 7-week experience will teach students the basics of web development for online services. Specifically, well focus on lightweight,<br/>minimal UI, microservices (e.g. bots, conversational interfaces, platform integrations, designing micro-interactions, etc.) Well introduce and examine these new web service trends and interactive experiences. Students will learn through instructor led workshops and hands-on experimentation. As an intro level course, no knowledge of programming is needed. By the end of the course, students will be able to design, prototype and deploy their own web-delivered services."
end

get "/units" do
 {units: 6.to_s}.to_json
end


get "/instructor" do
 
  name = "Daragh Byrne"
  email = "daragh@daraghbyrne.me"
  slack_str = "@daragh"

  { name: name, email: email, slack: slack_str }.to_json
   
end

get "/link_to/:item" do
  	#content_type :json
  if params[:item] == "slack"
    slack = settings.slack
	{course_slack: slack}.to_json
  elsif params[:item] == "site"
    site = settings.site
	{course_site: site}.to_json
  elsif params[:item] == "repo"
    repo = settings.repo
	{course_repo: repo}.to_json
  else
    400
  end
end


get "/meeting_times/:item" do

  if params[:item] == "class"

    start_str = settings.class_time_tuesday_start.strftime( "%A %H:%M" )
    end_str = settings.class_time_tuesday_end.strftime( "%A %H:%M" )
    duration = ( settings.class_time_tuesday_end - settings.class_time_tuesday_start  ) / 60

    { start: start_str, end_: end_str, duration_mins: duration }.to_json

  elsif params[:item] == "officehours"
    start_str = settings.office_hours_start.strftime( "%A %H:%M" )
    end_str = settings.office_hours_end.strftime( "%A %H:%M" )
    duration = (settings.office_hours_end - settings.office_hours_start ) / 60

    { start: start_str, end_: end_str, duration_mins: duration }.to_json
    
  else
    400
	end
end



get "/in_session" do

	session_start_time = Time.new( 2016, 11, 1, 12, 00 )
  session_end_time = session_start_time + 2.hour + 50.minutes
   
  is_in_session = false
  time_now = Time.now

  
  (1..8).each do |i|
  
    if time_now >= session_start_time and time_now <= session_end_time 
      is_in_session = true
    end

    session_start_time = session_start_time + 7.days
    session_end_time = session_end_time + 7.days
    
  end
  
  if is_in_session == true
      "Yes"
  else
      "No"
  end
  
  { now: time_now, in_session: is_in_session, in_session_string: ( is_in_session ? "YES" : "NO" ) }.to_json
  
end

get "/interesting_link" do

	link = Courselink.all.sample(1).first
  viewed = last_three_views
  
  return_string = "Try this link: #{link.url}<br/>"
  return_string += "<br/>Recently Viewed"
  viewed.each_with_index do |view, index|
    return_string += "<br/>#{index+1}. #{view}"
  end
  viewed link

  return_string
end

def reset_views
	session[:viewed] = []
end

def viewed link
   
  session[:viewed] ||= []
  session[:viewed] << link.url
  
end 

def last_three_views 
  session[:viewed] ||= []
  session[:viewed].last( 3 )
end 

error 403 do
  
  halt 403, 
  {output: "Access forbidden"}.to_json
end 

error 400 do
  
  halt 400,
  {output: "Bad Request. The parameters you provided are invalid"}.to_json
end 

error 401 do
	"Not allowed"
end

error 422 do
    {output: "Bad Request. The parameters you provided are invalid"}.to_json
end
