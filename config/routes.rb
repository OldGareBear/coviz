Rails.application.routes.draw do
  root to: 'counties#index'

  resources :counties

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
