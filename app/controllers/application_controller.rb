# frozen_string_literal: true

class ApplicationController < ActionController::API
  SECRET = ENV.fetch('SECRET_KEY_JWT')

  def current_user
    access_token = request.headers['access-token']&.split&.last
    begin
      user_id = decode(access_token)['user_id']
      @current_user = User.find(user_id)
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      @current_user = nil
    end
  end

  def encode(payload, exp = 30.minutes.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET, 'HS256')
  end

  def decode(token)
    JWT.decode(token, SECRET, true, { algorithm: 'HS256' })[0]
  end

  rescue_from CanCan::AccessDenied do
    render(json: { error: 'Unauthorized or invalid access token!' }, status: :unauthorized)
  end
end
