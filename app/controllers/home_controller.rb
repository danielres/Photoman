require 'find'

class HomeController < ApplicationController
  def index
    @albums = Album.all

    # @files = Dir.glob("albums/*")

    # @dirs = []
    # Find.find('./albums/') do |f| @dirs << f end
    # render :text => @dirs

    thumb_size = 100
    image_paths = Dir['albums/**/*.JPG'] + Dir['albums/**/*.jpg']

    @images = []
    image_paths.each{|path|
      url   = File.new(path).path.split('/').insert(1, thumb_size).join('/')
      exif  = {}
      e     = EXIFR::JPEG.new(path)
      exif[:model] = e.model
      exif[:date_time] = e.date_time
      exif[:width] = e.width
      exif[:height] = e.height
      @images << { :path => path, :url => url, :exif => exif }
    }

    #    @thumbs = jpgs.map{ |i| File.new(i).path.split('/').insert(1, thumb_size).join('/') }

    #    @thumbs = Hash[image_paths.map { |j|
    ##        photo = Magick::Image.read(v).first
    ##        date  = photo.get_exif_by_entry('DateTime')[0][1]
    ##        date  = DateTime.strptime(date, exif_date_format) if date
    ##        e = EXIFR::JPEG.new(v)
    #        [j, j*2]
    #    }.flatten]


  end
end
