class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:destroy, :update, :like ]
  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.save
    redirect_to posts_url
  end

  def index
    @post = current_user.posts.build
    @posts = Post.all.order(created_at: :desc)
  end

  def destroy
    redirect_to posts_url && return unless @post.user_id == current_user.id
    @post.destroy
    redirect_to posts_url
  end

  def update
    respond_to do |format|
      if @post.update_attributes(post_params)
        notice_message = 'Posts was successfully updated.'
        format.html { redirect_to(@post, notice: notice_message) }
      else
        format.html { render action: 'edit' }
      end
      format.json { respond_with_bip(@post) }
    end
  end
  def like
    if @post.liked_by current_user
        respond_to do |format|
          format.html { redirect_to :back }
          format.js
        end
      end
  end

  private

  def post_params
    params.require(:post).permit(:message)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
