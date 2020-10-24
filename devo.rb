require 'sinatra'
require 'sinatra/reloader'
require 'haml'
require 'sequel'
require 'rack'

set :bind, '0.0.0.0' if development?
set :haml, :format => :html5

BIBLE = Sequel.sqlite('bible.db')
BIBLE.freeze

VERSES = BIBLE[:webp_bible_data].freeze
BOOKS = BIBLE[:book_names].freeze

book_map = Hash.new
BOOKS.each do |b|
	book_map[b[:book_code]] = b
end
BOOK_MAP = book_map.freeze

get "/" do
	@books = BOOKS.all
	haml :index
end

get "/book/:code" do

	@vstart = vstart = VERSES.where(book: params[:code]).where(chapter: 1).where(startVerse: 1).first()[:canon_order]

	@vend = vend = VERSES.where(book: params[:code]).where(chapter: 1).where(startVerse: 1).first()[:canon_order]

	@book = BOOKS.where(book_code: params[:code]).first
	@verses = VERSES.where{canon_order >= vstart}.where(book: params[:code]).all

	chapters = []
	curr_chapter = 0

	@verses.each do |v|
		if v[:chapter] != curr_chapter then
			chapters.push({
				:num => v[:chapter],
				:canon_order => v[:canon_order]
			})
			curr_chapter = v[:chapter]
		end
	end

	@chapters = chapters

	haml :book

end


get "/range/:start/:end/" do

	@books = BOOK_MAP
	max_verse = VERSES.max(:canon_order)
	_start = Integer(params[:start])
	_end = Integer(params[:end])


	@link_add_start = "/range/#{[_start - 1,1].max}/#{_end}/"
	@link_add_end = "/range/#{_start}/#{[_end + 1, max_verse].min}/"
	@link_pop_start = "/range/#{[_start + 1, _end].min}/#{_end}/"
	@link_pop_end = "/range/#{_start}/#{[_end-1, _start].max}/"


	@verses = VERSES.where{canon_order >= _start}.where{canon_order <= _end }.all
	haml :passage
end