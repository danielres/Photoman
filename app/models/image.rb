class Image < ActiveRecord::Base
  belongs_to :album
  image_accessor :imagefile

end
