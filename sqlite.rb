require 'sqlite3'
db = SQLite3::Database.new 'zub'

db.execute "insert into contacts (email, message) values('povelkoea@gmail.com','Programist iz Znamenskoe')"
db.execute "select * from contacts" do |data|
	puts data
end

db.close
#insert into cars (name, price) values ('rav4', 10000)