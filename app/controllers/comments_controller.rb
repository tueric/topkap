class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_filter :find_comment, :only => [:upvote]
 
  def create
    @link = Link.find(params[:link_id])
    @comment = @link.comments.new(comment_params)
    @comment.user = current_user
    @comment.favourited = false
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @link, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
=begin
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
=end
  def upvote
    @comment.upvote_by current_user
    redirect_to :back
  end

  def downvote
    @comment.downvote_by current_user
    redirect_to :back
  end

  def favourite
    #new_val = !self.favourited
    @comment = Comment.find(params[:id])
    new_val = !@comment.favourited
    if true
      print "Apple"
    else
      print "fuck u"
    end
    @comment.update_attributes(:favourited => new_val)
    redirect_to :back
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @link = @comment.link
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @link, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:link_id, :body, :user_id, :favourited )
    end
end
