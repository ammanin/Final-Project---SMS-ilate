require "sinatra"
require 'json'
require 'sinatra/activerecord'
require 'rake'
require 'twilio-ruby'
require 'google-translate'
require 'wordnik'

configure :development do
  require 'dotenv'
  Dotenv.load
end

# enable sessions for this project
enable :sessions
client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]

get '/incoming_sms' do
	
  session["last_context"] ||= nil
  session["count"] ||=nil
  sender = params[:From] || ""
  body = params[:Body] || ""
  body = body.downcase.strip
  user_input = #something.body
  language = #something.body
if body == #check if the string in the right format 
#	message == translation + " For anything else reply with Menu"
elsif session["last_context"] = "play"
	if body 
elsif session["last_context"] = "dword"
	if body = #any of the google translate languages 
	session["dword_language"] = "#language"
	message = "What time of day would you like your word at? Reply in HH:MM. "
	elsif body = #check for right format
	
	#get random word from worknik api
	#translate word
	message = #translated word
elsif session["last_context"] = "revision"
elsif body == "menu"
	session["last_context"] = "menu"
	if session["counter"] = 0
	message = get_about_message
	else
	message = return_user_message
	end
elsif body == "dword"
	session["last_context"] = "dword"
	message = "As you wish. What's your daily word language?"
elsif body == "play"
	session["last_context"] = "play"
	if session ["count"] < 5 # or check that the database has atleast 5 items - should be another if statement for choosing language 
	message = "To unlock the game you must translate atleast 5 phrases or words"
	else
	#fill array with known languages - cross referencing user_id and language in database
	message = "As you wish. What language would you like to play? Reply with the number, name or all. " # + list of languages

	#play game
	end
	
elsif body == "revision"
	session["last_context"] = "revision"
	message = "As you wish. What language would you like to play? Reply with the number, name or all. " # + list of languages
elsif body == "profile"
	session["last_context"] = "profile"
	message = #phone number, name, points & langauges"
elsif body == "bye"
 	session["last_context"] = nil
else
	message = get_error
end

 session["counter"] +1

 end
 


	if body ==
	#take information from body
	#translate information
	message = translation + 
	elsif body == "play"
		if session["count"] < 6
			message = GREETINGS.sample + ", please translate a few more phrases to unlock the quiz"
		else 
		message = quiz_result
		end
		session["last_context"] = "play"


end



 twiml = Twilio::TwiML::Response.new do |r|
   r.Message message
 end
 twiml.text
	
end

def quiz_result
#workings of the quiz
end

def traslation
#should this be a seperate function?
	return
end
private 


GREETINGS = ["Hi","Namaste", "Guten Tag","Howdy", "Hello", "Ahoy", "â€˜Ello", "Aloha", "Hola", "Bonjour", "Hallo", "Ciao", "Konnichiwa"]
ERROR_MESSAGES = ["Whoops! That aint right", "Come on! You should know better", "You should be smarter by now. How have I not rubbed off on you?", "Really? Tsk Tsk"]

def get_error
	return ERROR_MESSAGES.sample + "Either reply with Menu or tell me what to translate in single quotes followed by a \'-\' and the language to translate it to. Ex. 'Hi! My name is SMSilate' - German"
end

def get_greeting
  return GREETINGS.sample
end

def get_about_message
	get_greeting + ", Welcome to SMS-ilate! The world’s first SMS language learner. Tell me what to translate in single quotes followed by a \'-\' and the language to translate it to. Ex. 'Hi! My name is SMSilate' - German or 
	Play - To take a quiz   
	Dword - To manage your daily word SMS
	Revision - To look at what you’ve learnt till now"
end

def return_user_message
	get_greeting + "! Back for more, are you? You know the drill! Reply with what you’d like translated or
	Play - To take a quiz
	Dword - To manage your daily word SMS
	Revision - To look at what you’ve learnt till now"
end
