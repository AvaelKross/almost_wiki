require "spec_helper"

describe PagesController do
	it "changing bold from wiki to html well" do
		controller = PagesController.new()
		controller.to_html_code('**alala**').should be == '<b>alala</b>'
	end
	it "changing bold from html to wiki well" do
		controller = PagesController.new()
		controller.to_wiki_code('<b>alala</b>').should be == '**alala**'
	end
	it "changing italic from wiki to html well" do
		controller = PagesController.new()
		controller.to_html_code('\\\\alala\\\\').should be == '<i>alala</i>'
	end
	it "changing italic from html to wiki well" do
		controller = PagesController.new()
		controller.to_wiki_code('<i>alala</i>').should be == '\\\\alala\\\\'
	end
	it "changing links from wiki to html well" do
		controller = PagesController.new()
		controller.to_html_code('((Page/page2/page3 text))').should be == '<a href="/Page/page2/page3">text</a>'
	end
	it "changing links from html to wiki well" do
		controller = PagesController.new()
		controller.to_wiki_code('<a href="/Page/page2/page3">text</a>').should be == '((Page/page2/page3 text))'
	end
	
end
		
