require "spec_helper"
describe Page do
	pageparams = {name: "alala", title: "somepage", content: "somecontent"}
	it "has no name" do
		page = Page.new
		page.should_not be_valid
	end
	it "has nice name" do
		page = Page.new(name: "hell10\u0410\u0420")
		page.name.should match(/^[A-Za-z0-9\u0410-\u044F]*$/)
	end
	it "has bad name" do
		page = Page.new(name: '``asdsad  ')
		page.name.should_not match(/^[A-Za-z0-9\u0410-\u044F]*$/)
	end
	it "changes database" do
		page = Page.new(pageparams)
		expect { page.save }.to change { Page.count }.by(1)
		page = Page.find_by_name("alala")
		page.name.should be == "alala"
	end
	describe "with precreating" do
		before(:each) do
			@page = Page.new(pageparams)
			@page.save
		end	
		it "have uniq name" do
			page = Page.new(pageparams)
			page.save.should be_false
		end
		it "generates link" do
			@page.link.should be == 'alala'	
		end
		describe "with parents" do
			before(:each) do
				@newpage = Page.create(name: "fruit", title: "banana", content: "nomnomnom")
				@newpage.move_to_child_of(@page)
			end
			it "generates link with path" do
				@newpage.link.should be == 'alala/fruit'
			end
			it "generates back link" do
				@newpage.backlink.should be == 'alala/'
			end
		end
	end
end
