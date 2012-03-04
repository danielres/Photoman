require 'find'

class HomeController < ApplicationController
  def index
    @albums = Album.all

    thumb_size = 100

    @years = Dir['albums/*/']
    year = params[:year].presence || File.basename(@years.last)
    image_paths = Dir["albums/#{year}/**/*.JPG"] + Dir["albums/#{year}/**/*.jpg"]
    @images = []
    image_paths.each{ |path|
      url               = File.new(path).path.split('/').insert(1, thumb_size).join('/')
      meta              = {}
      e                 = EXIFR::JPEG.new(path)
      xmp               = XMP.parse(e)
      meta[:model]      = e.model
      meta[:date_time]  = e.date_time
      meta[:width]      = e.width
      meta[:height]     = e.height
      meta[:tags]       = xmp.dc.subject rescue []
      meta[:rating]     = xmp.xmp.send('Rating').to_i rescue nil
      year              = path.split('/')[1]
      album             = path.split('/')[2]
      @images << {:year => year, :album => album, :path => path, :url => url, :meta => meta}
    }

    @images_by_albums = {}
    @images.each{ |i|
      @images_by_albums[ i[:album] ]  ||= []
      @images_by_albums[ i[:album] ]  <<  i
    }

    @images_by_tags = {}
    @images.each{ |i|
      i[:meta][:tags].each{ |t|
      @images_by_tags[ t ]  ||= []
      @images_by_tags[ t ]  <<  i
      }
    }


    @grouping_list = ['albums', 'tags']

    @images = @images_by_albums
    @images = @images_by_tags   if  params[:grouping] == 'tags'

  end
end
