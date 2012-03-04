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
      @images << { :path => path, :url => url, :meta => meta }
    }

#    testimage = EXIFR::JPEG.new('albums/2002-09-19 16-07-31 moustique 03.JPG')
#    xmp = XMP.parse(testimage)


#    attrs = []
#    xmp.namespaces.each{ |ns|
#      namespace = xmp.send(ns)
#      namespace.attributes.each{ |attr|
#        attrs << "#{ns}.#{attr}: " + namespace.send(attr).inspect
#      }
#    }






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
