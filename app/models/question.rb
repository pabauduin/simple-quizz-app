class Question < ApplicationRecord
	belongs_to :user
	attr_accessor :user_answer
end
