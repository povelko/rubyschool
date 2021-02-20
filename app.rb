#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

#configure do
#	@db = SQLite3::Database.new 'zub.db'
#end
def sql
	@db = SQLite3::Database.new 'zub.db'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end
get '/about' do
	erb :about
end

get '/visit' do 
		@error 
	erb :visit
end

get '/contacts' do
	erb :contacts
end

get '/admin' do
	erb :admin
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@date = params[:date]
	@lgota = params[:lgota]
	@color = params[:color]
		hh = {:username=>"Введите имя пациента",
			  :date=>"Введите дату посещения",
			  :phone=>"Введите номер телефона"}
	
@error = hh.select { |key| params[key]==""}.values.join(", ")
	#hh.each do |key,value|
	#	if params[key] == ''
	#			@error = hh[key]
	#			return erb :visit
	#		end
	#	end
if @error !=""
	return erb :visit
end
	#сохранение в бд
	sql
	@db.execute 'INSERT INTO visit  (pacient, date_visit, phone, lgota) values (?, ?, ?, ?)', [@username, @date, @phone, @lgota] 
	value = "ФИО: #{@username}| Телефон:#{@phone}| Дата и время:#{@date}#{@lgota} цвет: #{@color}"
	add = File.open "./public/"+@username+".txt", "a"
	add.write value
	add.close
	redirect '/'			
end

post '/contacts' do
	require 'pony'
	@email = params[:email]
	@text = params[:text]
		hh = {:email=>"Не ввели адрес эл. почты",
			  :text=>"Не заполнили сообщение"}
		@error = hh.select { |key| params[key]==""}.values.join(", ")
						
						if @error != ""
							return erb :contacts
						end

	value = "Эл. адрес: #{@email}| Сообщение:#{@text}"
	add= File.open "./public/" + @email + ".txt", "a"
	add.write value
	add.close

Pony.mail ({ 
		:subject => "Привет из программы на руби!",
		:body => @text,
		:to => @email,
		:from => 'znamcrb@bk.ru',
		:via => :smtp,
		:via_options => {
			:address => 'smtp.mail.ru',
			:port => '465',
			:tls => true,
			:user_name => 'znamcrb@bk.ru',
			:password => 'KriUTyTou32%',
			:authentication => :plain}
})
	redirect '/'	
end
before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end
post '/login/attempt' do
    @login = params['login']
    @pass = params['pass']
      if @login =='admin' && @pass == '333'

          session[:identity] = params['username']
          where_user_came_from = session[:previous_url] || '/'
          redirect to where_user_came_from
      else 
          @error = 'Sorry, you need to be logged in to visit ' + request.path
      end
end
get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end

get '/secure/place' do
  erb 'This is a secret place that only <%=session[:identity]%> has access to!'
end