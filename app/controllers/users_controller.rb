class UsersController < ApplicationController
  def ranking
    @users = User.select("users.name, comments.created_at as data, COUNT(comments.id) as count_comments")
                 .joins(:comments)
                 .group("users.id")
                 .order("count_comments DESC")
                 .where('data >= ?', 1.week.ago)
                 .limit(10)
  end
end
