class BlogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_blog, only: [:edit, :update, :destroy]
  
  PERMISSIBLE_ATTRIBUTES = %i(picture picture_cache)

  def index
   @blogs = Blog.all
   #raise
  end

  def new
    if params[:back]
      @blog = Blog.new(blogs_params)
    else
      @blog = Blog.new
    end
  end

  def create
   @blog = Blog.new(blogs_params)
  @blog.user_id = current_user.id
   if @blog.save
        redirect_to blogs_path, notice: "投稿しました！"
        NoticeMailer.sendmail_blog(@blog).deliver
   else
        render 'new'
   end
  end

  def edit
    @blog = Blog.find(params[:id])
  end

  def update
    @blog = Blog.find(params[:id])
    @blog.update(blogs_params)
    redirect_to blogs_path, notice: "編集しました！"
  end

  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy
    redirect_to blogs_path, notice: "削除しました！"
  end
  
  def confirm
    @blog = Blog.new(blogs_params)
    render :new if @blog.invalid?
  end

  private
    def blogs_params
      params.require(:blog).permit(:picture, :picture_cache, :content)
    end
    
    def set_blog
      @blog = Blog.find(params[:id])
    end
end
