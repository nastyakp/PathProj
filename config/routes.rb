Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/dir/:path',   to: 'path#dir',   constraints: {path: /.*/}
  get '/files/:path', to: 'path#files', constraints: {path: /.*/}
  # нужно разделение с constraints и без, чтобы не дать доступ к директориям
  # названия которых включает в себя название корневой дир.
  # нпр: корн.дир - /home/rootdir и /home/rootdir_notreally
  get '/dir',   to: 'path#dir'
  get '/files', to: 'path#files'
end
