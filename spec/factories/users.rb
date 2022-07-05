# frozen_string_literal: true

FactoryBot.define do
  factory :user, Class: 'User' do
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password }
    password_confirmation { Faker::Internet.password }
  end
end
