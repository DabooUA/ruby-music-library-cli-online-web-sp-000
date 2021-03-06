class Song

  extend Concerns::Findable

  @@all = []

  attr_accessor :name
  attr_reader :artist, :genre

  def initialize(name, artist = nil, genre = nil)
    @name = name
    self.artist = artist if artist != nil
    self.genre = genre if genre != nil

  end

  def self.all
    @@all
  end

  def self.destroy_all
    @@all.clear
  end

  def save
    @@all << self
  end

  def self.count
    @@all.size
  end

  def self.create(name)
    new_name = self.new(name)
    new_name.save
    new_name
  end

  def artist=(artist)
    @artist = artist
    artist.add_song(self)
  end

  def genre=(genre)
    @genre = genre
    genre.songs << self unless genre.songs.include?(self)
  end

  def self.new_from_filename(file)
    parts = file.split(" - ")
    artist, name, genre = parts.first, parts[1], parts[2].gsub( ".mp3" , "")

    artist = Artist.find_or_create_by_name(artist)
    genre = Genre.find_or_create_by_name(genre)
    song = self.find_or_create_by_name(song)

    self.new(name, artist, genre)

  end

  def self.create_from_filename(file)
    self.new_from_filename(file).save
  end

  def self.find_by_name(name)
    @@all.detect {|song| song.name == name}
  end

  def self.find_or_create_by_name(name)
    self.find_by_name(name) || self.create(name)
  end
end
