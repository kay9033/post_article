Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  } 

  root 'articles#index'
  
  resources :articles
  get "up" => "rails/health#show", as: :rails_health_check
end
