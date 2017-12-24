class Blog < ActiveRecord::Base
    validates :content, presence: true
    belongs_to :user
    
    mount_uploader :picture, PictureUploader
end
