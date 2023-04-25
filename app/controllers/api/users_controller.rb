class Api::UsersController < ApplicationController
	before_action :set_user, only: [:show, :update, :destroy]

	def index
		@users = User.all
		if @users.present?
			render json: Api::UserSerializer.new(@users).serializable_hash, status: :ok
		else
			render json: {message: "Users not present"}
		end
	end

	def create
		@user = User.new(user_params)
		if @user.save
			render json: Api::UserSerializer.new(@user).serializable_hash, status: :created
		else
			render json: @user.errors
		end
	end

	def typehead
		if params[:querry].present?
			query = params[:querry]
			@users = User.or(
				{first_name: /#{query}/i}, 
				{last_name: /#{query}/i}, 
				{email: /#{query}/i})
			render json: Api::UserSerializer.new(@users).serializable_hash, status: :ok
		else
			render json: {message: "user not present with #{params[:query]}"}
		end
	end

	def show
		if @user.present?
			render json: Api::UserSerializer.new(@user).serializable_hash, status: :created
		else
			render json: {message: "user doesn't exit with id #{params[:id]}"}
		end
	end

	def update
		if @user.update(user_params)
			render json: Api::UserSerializer.new(@user).serializable_hash, status: :created
		else
			render json: @user.errors, status: :unprocessable_entity
		end
	end

	def destroy
		if @user.present?
			@user.destroy
			render json: {message: "user deleted successfully"}
		else
			render json: {message: "user doesn't exit with id #{params[:id]}"}
		end
	end

	private

	def set_user
		@user = USer.find_by(id: params[:id])
	end

	def user_params
		params.require(:user).permit(:first_name, :last_name, :email)
	end
end
