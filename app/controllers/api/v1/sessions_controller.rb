# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      def signup
        @user = User.new(user_params)

        if @user.save
          render(json: @user, status: :created)
        else
          render(json: @user.errors, status: :unprocessable_entity)
        end
      end

      def login
        @user = User.find_by(email: user_params[:email])

        if @user&.valid_password?(user_params[:password])

          token = encode({ user_id: @user.id })

          render(json: { token: token, user: UserSerializer.new(@user) })
        else
          render(json: { message: 'Invalid information!' }, status: :unauthorized)
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end
