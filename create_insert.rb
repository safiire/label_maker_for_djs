#!/usr/bin/env ruby

class Label

  Template = <<-STR
    <!DOCTYPE html>
    <html lang="en"> <head> <meta charset="utf-8" /> <link rel="stylesheet" type="text/css" href="../0000 - Disc Label Maker/cd_template.css" /> </head>
      <body> %s </body>
    </html>
  STR


  ####  
  class Track
    attr_accessor :track_number, :key, :bpm, :artist, :title
    ColorMap = %w{#aaaaaa #00f2cd #00f581 #2df846 #eacb69 #ff9c73 #ff808e #ff77b1 #ff77da #db87ff #8cb5ff #00dbfd #00efef'}

    Template = <<-STR
      <tr style="background-color: %s;"><td>%s</td> <td>%s</td> <td>%s</td> <td>%s</td> <td>%s</td> </tr>
      <tr> <td class="times" colspan="5"> Cue: _____:_____ Drop: _____:_____ End: _____:_____ </td> </tr>
    STR

    ####  Exceptions
    class BadFilename < StandardError; end

    ####
    ##  Initialize 
    def initialize(filepath)
      filename = File.basename(filepath)
      md = filename.match(/(\d\d) - (\d\d) (\d{1,3}) "([^"]+)" - "([^"]+)"/)
      raise BadFilename.new("Error: #{filename} is not in the correct format") if md.nil?
      _, @track_number, @key, @bpm, @artist, @title = md.to_a
    end


    ####
    ##  Track as a string is an html table row
    def to_s
      color = ColorMap[@key.to_i]
      attributes = [color, @track_number, @bpm, @key, @artist, @title]
      Template % attributes
    end

  end


  class Insert

    Template = <<-STR
      <div class="insert"> <table> <caption>%s</caption> 
        <thead> <tr> <th>#</th> <th>BPM</th> <th>Key</th> <th>Artist</th> <th>Title</th> </tr> </thead>
        <tbody> %s </tbody>
      </table> </div>
    STR

    ####
    ##  Initialize
    def initialize(album_title, tracks)
      @album_title = album_title
      @tracks = tracks
    end


    ####
    ##  Insert as an html string
    def to_s
      tracks_html = @tracks.inject('') do |html, track|
        html += track.to_s
      end
      Template % [@album_title, tracks_html]
    end

  end

  ####  Descriptive Exceptions
  class BadDirectory < StandardError; end

  ####
  ##  Initialize with an albums track data file
  def initialize(directory)
    raise BadDirectory.new("#{directory} does not exist") unless Dir.exists?(directory)
    @directory = directory
    @album_title = File.basename(directory)
    @tracks = Dir["#{directory}/*"].map do |filepath|
      Track.new(filepath) rescue next
    end
  end


  ####
  ##  To a string of html
  def to_s
    inserts_html = partition(@tracks).inject('') do |html, tracks|
      html += Insert.new(@album_title, tracks).to_s
    end
    Template % [inserts_html]
  end


  ####
  ##  Partition the tracks up into two inserts
  def partition(tracks)
    track_count = tracks.size
    track_numbers = (0...track_count).to_a
    half = track_count / 2.0
    half_rounded = half.round
    range_one = 0...(half_rounded.pred)
    range_two = (half_rounded.pred)...(track_count.pred)
    [tracks.slice(range_one), tracks.slice(range_two)].reject(&:nil?)
  end


  ####
  ##  Write the html into the album directory
  def write
    filename = "#{@directory}/label.html"
    File.open(filename, 'w') do |fp|
      fp.puts(self.to_s)
    end
    puts "Wrote #{filename}"
  end
end



##  If we are running the program rather than just requiring it.
##  This way we can use this as a library
if __FILE__ == $0

  my_dir = File.dirname(File.expand_path(__FILE__))

  directories = ARGV.empty? ? Dir['../*'].select{|d| File.directory?(d)} : ARGV.clone
  directories.map!{ |directory| File.expand_path(directory) }
  directories -= [my_dir]

  directories.each do |directory|
    label = Label.new(directory)
    label.write
  end
end
