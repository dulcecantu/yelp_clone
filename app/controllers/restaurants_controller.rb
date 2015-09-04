class RestaurantsController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = current_user.restaurants.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    p 'updating restaurant, params:'
    p params
    @restaurant = Restaurant.find(params[:id])

    p "restaurant found, it's #{@restaurant}"
    if @restaurant.update_as(current_user, restaurant_params)
      p "Restaurant was updated, now redirecting..."
      redirect_to restaurants_path
      flash[:notice] = "Restaurant successfully updated"
    else
      p "Restaurant was not updated, heading back."
      redirect_to restaurants_path
      flash[:notice] = "You cannot edit someone else's restaurant"
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])

    if @restaurant.delete_as(current_user)
      redirect_to restaurants_path
      flash[:notice] = "Restaurant successfully deleted"
    else
      redirect_to restaurants_path
      flash[:notice] = "You cannot delete someone else's restaurant"
    end
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :image)
  end
end
