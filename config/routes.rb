Rails.application.routes.draw do
  root to: "items#index"
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
  }

  devise_scope :user do
    get 'users/select' => 'users/registrations#select'
    get 'users/confirm_phone' => 'users/registrations#confirm_phone'
    get 'users/new_address' => 'users/registrations#new_address'
    post 'users/create_address' => 'users/registrations#create_address'
  end

  
  resources :users, only: [:show]

  resources :items, only: [:index, :new, :create, :show, :edit, :update, :destroy]  do
    member do
      get "purchase_confirmation"
      post "purchase" 
    end
    collection do
      get 'search'
    end
  end
  resources :categories, only: [:index, :show]
  resources :cards, only: [:index, :new, :create, :destroy]

  namespace :api do
    resources :categories, only: :index, defaults: { format: 'json' }
  end
end
