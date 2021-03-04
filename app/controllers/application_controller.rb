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
      redirect_to("/user_sign_in", { :notice => "You have to sign in first." })
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

      followers = @user.received_follow_requests

      @accepted_followers = followers.where({:status => "accepted"})
      @pending_followers = followers.where({:status => "pending"})

      following = @user.sent_follow_requests
      @accepted_following = following.where({:status => "accepted"})

      accept = FollowRequest.all.where({:status => "accepted"})
      @follows = accept.where({:recipient_id => @user.id, :sender_id => @current_user.id}).or(
        accept.where({:recipient_id => @current_user.id, :sender_id => @user.id})
        )




    render({:template => "users/show.html.erb"})

    else
    
    redirect_to("/user_sign_in", { :notice => "You have to sign in first." })
    
    end

  end


end
