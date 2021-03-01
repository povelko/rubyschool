require 'rubygems'
#require 'sinatra'
#require 'sinatra/reloader'
require 'sqlite3'
#require 'mysql2'

db = SQLite3::Database.new 'zub.db'
db.results_as_hash = true

	@arr = []
#db.execute "insert into contacts (email, message) values('povelkoea@gmail.com','Programist iz Znamenskoe')"
db.execute 'select * from visit order by pacient' do |row|

		
		@arr << row
		#@pac = row["pacient"]

		
end
resultat=''
last=''
puts @arr.count
0.upto(@arr.count-1) do |x|

resultat =  "<td><%= @sql_v[#{x}][1]%></td> <td><%= @sql_v[#{x}][2]%></td><td><%= @sql_v[#{x}][3]%></td><td><%= @sql_v[#{x}][4]%></td>" + last
last = resultat

	end
puts resultat
db.close
#insert into cars (name, price) values ('rav4', 10000)