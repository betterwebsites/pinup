Rails.application.routes.draw do

  resources :sources do
    collection do
      post :import
    end
  end

  root to: 'root#home'

  devise_for :users, controllers: { registrations: 'users/registrations',
                                    sessions: 'users/sessions',
                                    omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :artists
  resources :venues,  except: [ :destroy ]
  resources :events do
    collection do
      get :list_artists
      post :import
    end
  end

  namespace :admin do
    get 'dashboard', to: 'dashboard#home'
    get 'load_google_calendars', to: 'dashboard#load_google_calendars'
    
    # get 'authorize_all', to: 'dashboard#authorize_all'
    # get 'delete_all_ads', to: 'dashboard#delete_all_ads'
    # get 'delete_all_banners', to: 'dashboard#delete_all_banners'

    resources :users
    
    resources :ads do
      collection do
        delete :destroy_all
      end
    end

    resources :banners do
      collection do
        delete :destroy_all
      end
    end

    resources :csv_calendars

    resources :artists
    
    resources :venues
    
    resources :events do
      member do
        patch :authorize
        patch :unauthorize
      end
      
      collection do
        patch :authorize_all
      end
    end

    require "sidekiq/web"
    mount Sidekiq::Web => '/sidekiq'

  end
    get '/blog', to: 'static_pages#blog', as: 'blog'
    get 'download_csv_template', to: 'application#download_csv_template'
end
