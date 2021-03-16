# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :integer
#  photo_id   :integer
#
class Comment < ApplicationRecord

#Validations

validates(:photo_id, { :presence => true })

validates(:author_id, { :presence => true })

#Methods

belongs_to(:commenter, { :class_name => "User", :foreign_key => "author_id" })

belongs_to(:photo, { :counter_cache => true })

end
