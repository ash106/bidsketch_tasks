class Email < ActiveRecord::Base
  validates :message_id, uniqueness: true
end
