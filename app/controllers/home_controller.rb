require 'find'

class HomeController < ApplicationController
  def index

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

    storage_mode = 'S3'

    if storage_mode == 'S3'
        connection  = Fog::Storage.new({
                        :provider => 'AWS',
                        :aws_access_key_id => ENV['S3_KEY'],
                        :aws_secret_access_key => ENV['S3_SECRET']
                      })
        expiration  = 1.year
        files       = connection.directories.get(ENV['S3_BUCKET']).files
        urls        = files.map{|f| f.url(  (Time.now + expiration).to_i  )}
    end

  end
end
