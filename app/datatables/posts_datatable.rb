class PostsDatatable
  delegate :params, :h, :link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Post.count,
      iTotalDisplayRecords: posts.total_entries,
      aaData: data
    }
  end

private

  def data
    posts.map do |post|
      [
	link_to(post.name, post),
        h(post.title)
      ]
    end
  end

  def posts
    @posts ||= fetch_posts
  end

  def fetch_posts
    posts = Post.order("#{sort_column} #{sort_direction}")
    posts = posts.page(page).per_page(per_page)
    if params[:sSearch].present?
      posts = posts.where("name like :search or title like :search", search: "%#{params[:sSearch]}%")
    end
    posts
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[name title ]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
