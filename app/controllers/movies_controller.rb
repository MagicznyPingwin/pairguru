class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]

  def index
    @movies = Movie.all.decorate
  end

  def show
    @movie = Movie.find(params[:id])
    @comments = @movie.comments
    unless current_user.comments.where(movie_id: params[:id]).count >= 1
      @new_comment = Comment.new
    end
  end

  def create_comment
    @new_comment = Comment.new(comment_params)
    if @new_comment.save
      redirect_to movie_path(params[:id])
      flash[:notice] = "Comment has been created successful"
    end
  end

  def send_info
    @movie = Movie.find(params[:id])
    MovieInfoMailer.send_info(current_user, @movie).deliver_now
    redirect_back(fallback_location: root_path, notice: "Email sent with movie info")
  end

  def export
    file_path = "tmp/movies.csv"
    MovieExporter.new.call(current_user, file_path)
    redirect_to root_path, notice: "Movies exported"
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :movie_id, :user_id)
  end
end
