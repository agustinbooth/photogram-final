class ApplicationController < ActionController::Base
  before_action(:load_current_user)
  
  # Uncomment this if you want to force users to sign in before any other actions
  # before_action(:force_user_sign_in)
  
  def load_current_user
    the_id = session[:user_id]
    @current_user = User.where({ :id => the_id }).first
  end
  
  def force_user_sign_in
    if @current_user == nil
      redirect_to("/user_sign_in", { :alert => "You have to sign in first." })
    end
  end

  def index

    matching_users = User.all
    @list_of_users = matching_users.order({:username => :asc})

    if @current_user.present?

    matching_follows = FollowRequest.all
    @list_of_follows = matching_follows.where({:sender_id => @current_user.id})

    else
    end

  render({:template => "users/index.html.erb"})
  end

  def show

    if @current_user.present?
  
      username = params.fetch("username")
      @user = User.all.where({:username => username}).first
      follow_request = FollowRequest.where({ :sender_id => @current_user.id, :recipient_id => @user.id }).first

      followers = @user.received_follow_requests

      @accepted_followers = followers.where({:status => "accepted"})
      @pending_followers = followers.where({:status => "pending"})

      following = @user.sent_follow_requests
      @accepted_following = following.where({:status => "accepted"})

      accept = FollowRequest.all.where({:status => "accepted"})
      @follows = accept.where({:recipient_id => @user.id, :sender_id => @current_user.id}).or(
      accept.where({:recipient_id => @current_user.id, :sender_id => @user.id})
      )

      if follow_request.present? && follow_request.status == "accepted"

        render({:template => "users/show.html.erb"})

      elsif username == @current_user.username

        render({:template => "users/show.html.erb"})

      elsif @user.private == false

        render({:template => "users/show.html.erb"})

      else

       redirect_to("/", { :alert => "You're not authorized for that." })  
        
      end


    else
    
    redirect_to("/user_sign_in", { :alert => "You have to sign in first." })
    
    end

  end

  def feed

  @user = User.all.where({:username => params.fetch("username")}).first

  followers = @user.received_follow_requests
  @accepted_followers = followers.where({:status => "accepted"})

  following = @user.sent_follow_requests
  @accepted_following = following.where({:status => "accepted"})

  following_users = Array.new

  @accepted_following.each do |a_follow|
  
    following_users.push(a_follow.recipient)

  end 
  
  @feed = Array.new
  feed_photos = Array.new

  following_users.each do |a_user|
  
    feed_photos.push(a_user.own_photos)

  end 

  feed_photos.each do |a_photo_array|

    a_photo_array.each do |a_photo|
  
    @feed.push(a_photo)

    end

  end

   @feed = @feed.sort_by { |h | h[:created_at] }.reverse


  render({:template => "users/feed.html.erb"})

  end

  def liked_photos

    @user = User.all.where({:username => params.fetch("username")}).first
    followers = @user.received_follow_requests
    @accepted_followers = followers.where({:status => "accepted"})

    following = @user.sent_follow_requests
    @accepted_following = following.where({:status => "accepted"})
    
    @liked_photos = @user.liked_photos

    render({:template => "users/liked_photos.html.erb"})

  end


end
