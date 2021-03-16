class PhotosController < ApplicationController
  def index
    public_users = User.where({ :private => false })
    matching_photos = Photo.all.where(:owner => public_users)

    @list_of_photos = matching_photos.order({ :created_at => :desc })

    render({ :template => "photos/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_photos = Photo.where({ :id => the_id })
    @the_photo = matching_photos.at(0)   

    if @current_user.present?

    follow_request = FollowRequest.where({ :sender_id => @current_user.id, :recipient_id => @the_photo.owner.id }).first   

    render({ :template => "photos/show.html.erb" })

    else

    redirect_to("/user_sign_in", { :alert => "You have to sign in first." })  

    end  
    
  end

  def create
    the_photo = Photo.new
    the_photo.caption = params.fetch("query_caption")
    the_photo.image = params.fetch("query_image")
    the_photo.owner_id = @current_user.id

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos", { :notice => "Photo created successfully." })
    else
      redirect_to("/photos", { :notice => "Photo failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.caption = params.fetch("query_caption")
    the_photo.image = params.fetch(:query_image)
    the_photo.owner_id = @current_user.id
    the_photo.likes_count = the_photo.likes_count
    the_photo.comments_count = the_photo.comments_count

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos/#{the_photo.id}", { :notice => "Photo updated successfully."} )
    else
      redirect_to("/photos/#{the_photo.id}", { :alert => "Photo failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.destroy

    redirect_to("/photos", { :notice => "Photo deleted successfully."} )
  end
end
