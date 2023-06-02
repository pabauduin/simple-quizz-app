Rails.application.routes.draw do
  # Root route
  root to: 'users#index'
  resources :users do
    # Nested routes for the inner resource (e.g., questions)
    resources :questions do
      post 'validate', on: :member
    end
  end

  # Users routes
  resources :users, only: [:index, :new, :create, :show]

  # Questions routes
  resources :questions, only: [:index, :show]
end