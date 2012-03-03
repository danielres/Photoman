class Image < ActiveRecord::Base
  belongs_to :album
  image_accessor :imagefile

  validates :album,     :presence => true
  validates :imagefile, :presence => true

end
