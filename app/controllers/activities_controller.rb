class ActivitiesController < ApplicationController

	before_action :authenticate_user 
	before_action :get_activity, only: [:show, :edit, :update, :destroy]
	
	def index
		@activities = current_user.activities
		# @cs = Geocoder.coordinates(@activity.location)
		# @lat = @cs[0]
		# @lng = @cs[1]
	end

	def show
		@cs = Geocoder.coordinates(@activity.location)
		@lat = @cs[0]
		@lng = @cs[1]
	end

	def new
		@activity = Activity.new
		@category = Category.all
	end

	def create
		@activity = current_user.activities.new(activity_params)
    	respond_to do |format|
	      	if @activity.save 
	       	  format.html { redirect_to activities_path }
	          format.json { render action: 'index', status: :created, location: @activity }
	      	else
	         format.html { render action: 'new' }
	         format.json { render json: @activity.errors, status: :unprocessable_entity }
	        end
    	end
	end

	def edit
		@categories = Category.all
	end

	def update
		respond_to do |format|
		if @activity.update_attributes(activity_params)
			format.html { redirect_to activity_path }
			format.json { head :no_content }
		else
			format.html { render action: 'edit' }
        	format.json { render json: @activity.errors, status: :unprocessable_entity }
      	end
	end
	end

	def destroy
		@activity.destroy
		respond_to do |format|
			format.html { redirect_to activities_path }
			format.json { head :no_content }
		end
	end

  private

    def get_activity
		@activity = Activity.find(params[:id])
	end

	def activity_params
		params.require(:activity).permit(:name, :location, :link, :notes, :category_ids => [])
	end

end
