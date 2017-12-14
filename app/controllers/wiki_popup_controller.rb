class WikiPopupController < ApplicationController
  unloadable
  default_search_scope :wiki_pages
  before_action :find_wiki, :authorize
  before_filter :find_existing_page, :only => [:wiki_diff]

  layout false
  # helper :issues
  # helper :custom_fields

  def wiki_diff
    @diff = @page.diff(params[:version], params[:version_from])
    render_404 unless @diff
  end

private

  def find_wiki
    @project = Project.find(params[:project_id])
    @wiki = @project.wiki
    render_404 unless @wiki
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  # Finds the requested page and returns a 404 error if it doesn't exist
  def find_existing_page
    @page = @wiki.find_page(params[:id])
    if @page.nil?
      render_404
      return
    end
    # if @wiki.page_found_with_redirect?
    #   redirect_to_page @page
    # end
  end

end
