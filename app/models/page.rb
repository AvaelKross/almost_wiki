class Page < ActiveRecord::Base
  attr_accessible :content, :name, :title
  acts_as_nested_set
  validates_format_of :name, :with => /^[A-Za-z0-9\u0410-\u044F]*$/i
	validates :name, :presence => true, :uniqueness => true
	validates :content, :presence => true
  
	def link
		return prepare_link + self.name
	end

	def backlink
		return prepare_link
	end

	private
	def prepare_link
		link = ""
		self.ancestors.each do |node|
			link += node.name + "/"
		end
		return link
	end

end
