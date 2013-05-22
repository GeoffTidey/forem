Forem::Engine.routes.draw do
  root :to => "forums#index"

  resources :foro, controller: "forums", :only => [:index, :show], :as => :forum do
    resources :mensaje, controller: "topics", :as => :topic do
      member do
        get :subscribe
        get :unsubscribe
      end
    end
  end

  resources :mensaje, controller: "topics", :only => [:new, :create, :index, :show, :destroy], :as => :topic do
    resources :posts
  end

  get 'foro/:forum_id/moderation', :to => "moderation#index", :as => :forum_moderator_tools
  # For mass moderation of posts
  put 'foro/:forum_id/moderate/posts', :to => "moderation#posts", :as => :forum_moderate_posts
  # Moderation of a single topic
  put 'foro/:forum_id/mensaje/:topic_id/moderate', :to => "moderation#topic", :as => :moderate_forum_topic

  resources :categoria, controller: "categories", :only => [:index, :show], :as => :category

  namespace :admin do
    root :to => "base#index"
    resources :groups do
      resources :members
    end

    resources :forums do
      resources :moderators
    end

    resources :categories
    resources :topics do
      member do
        put :toggle_hide
        put :toggle_lock
        put :toggle_pin
      end
    end

    get 'users/autocomplete', :to => "users#autocomplete"
  end
end
