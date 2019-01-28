Rails.application.routes.draw do
  resources :payrolls, only: [:index, :upload] do
    collection do
      match :upload, via: [:post]
    end
  end

  root to: 'payrolls#index'
end
