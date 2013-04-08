class String
#converts string from wiki codes to html codes
  def to_html_code
	self.gsub!(/\*\*(.*)?(\*\*)/, '<b>\1</b>')
  	self.gsub!(/\\\\(.*)?(\\\\)/, '<i>\1</i>')
  	self.gsub!(/\(\(([A-Za-z0-9\u0410-\u044F\/]*)\s(.*)?(\)\))/, '<a href="/\1">\2</a>')
  end
  
  #converts string from html codes to wiki codes
  def to_wiki_code
  	self.gsub!(/<b>(.*)?(<\/b>)/,'**\1**')
  	self.gsub!(/<i>(.*)?(<\/i>)/,'\\\\\\\\\1\\\\\\\\')
  	self.gsub!(/<a href="\/(.*)?">(.*)?(<\/a>)/,'((\1 \2))')
  end
end

class PagesController < ApplicationController
  before_filter :process_path, :only => [:show, :new, :edit, :update]
  before_filter :find_page, :only => [:show, :edit]
	caches_page :show
	
  # GET /pages
  def index
    if Page.any?   #generate tree
      @tree=[]
      Page.roots.each do |root|
      	@tree += root.self_and_descendants
      end
    else
      flash[:notice] = "There's no pages in catalog"
    end
  end

  # GET (*name){0,1}
  def show
  end

  # GET 
  def new
    @page = Page.new
  end

  # GET (*name){0,1}/edit
  def edit
  	expire_page :action => :show
  	@page.content = @page.content.to_wiki_code
  end

  # POST /pages
  def create
    @page = Page.new({
    	:name => params[:page][:name],
    	:title => params[:page][:title],
    	:content => params[:page][:content].to_html_code
    	})
    #convert codes to html on create
    respond_to do |format|
      if @page.save
        unless params[:page][:parent_name].nil?
          @parent = Page.find_by_name(params[:page][:parent_name])
          @page.move_to_child_of(@parent)
        end
        format.html { redirect_to page_path(@page.link)}
      else
        format.html { render action: "new", notice: 'Error create page' }
      end
    end
  end

  # PUT /pages/1
  def update
		@page = Page.find(params[:id])
    respond_to do |format|
      if @page.update_attributes({
    	:title => params[:page][:title],
    	:content => params[:page][:content].to_html_code
    	})
        format.html { redirect_to page_path(@page.link)}
      else
        format.html { render action: "edit" }
      end
    end
  end
	
	#getting name and path
  def process_path
    unless params[:name].nil?
      #get path from params
      @path = params[:name]

      #get last section which is page name
      @name = @path.split("/").last
    end
  end

  #find page by name
  private
  def find_page
    if !@name.nil?
      @page = Page.find_by_name(@name)
    else
      flash[:notice] = "There's no such page!"
    end
  end
  
end
