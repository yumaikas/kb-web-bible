# KB-Bible

## About
This is a bare-bones Ruby/Sinatra-based viewer for the Protestant version of the World English Bible.

## Setup

To set this up, install sqlite3. Then run `sqlite3 bible.db`. Once the sqlite command prompt is up, run `.read create-bible-db.sql` to populate the database.

`bundle install` should take care of the gems needed for the server.

## Running

To run the server, after setting up, run `ruby devo.rb`

