require 'rubygems'
#require 'sinatra'
#require 'sinatra/reloader'
require 'sqlite3'
#require 'mysql2'

db = SQLite3::Database.new 'zub.db'
db.results_as_hash = true

	@arr = []
#db.execute "insert into contacts (email, message) values('povelkoea@gmail.com','Programist iz Znamenskoe')"
db.execute 'CREATE TABLE contacts (
    id    INTEGER       PRIMARY KEY AUTOINCREMENT
                        UNIQUE,
    email VARCHAR (100),
    text  TEXT
)'


