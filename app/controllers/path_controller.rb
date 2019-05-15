class PathController < ApplicationController

	def dir
    @path = prepared_path
    @tree = make_tree(prepared_path, 1)
    rescue Errno::ENOENT => e
      @path = e.message
      @tree = {}
    rescue Errno::ENOTDIR => e 
      @path = e.message
      @tree = {}
	end 

	def files
    @path = prepared_path
    # из дир-й и файлов выбрать файлы и из объектов -> стринги
    @files = Pathname.new(@path).each_child(false).select(&:file?).collect(&:to_s)
    rescue Errno::ENOENT => e
      @path = e.message
      @files = {}
    rescue Errno::ENOTDIR => e 
      @path = e.message
      @files = {}
  end

  private 

    def prepared_path
      # в парамс может ничего не лежать, а nil + string = error. 
      # (+) в парамс (см. руты) нужно добавить '/'
      Rails.configuration.root_path + (params[:path] == nil ? '' : '/' + params[:path]) 
    end

    def make_tree(path, deep)
      # рекурсивно получить дерево
      return {} if deep >= 100
      deep += 1
      _hash = {}
      Pathname.new(path).each_child do |c| 
        if c.directory?
          # если экзпляр - дир-я, то если пустая - просто добавить, иначе рекурсия
          _hash[c.basename.to_s] = (c.empty? ? {} : make_tree(path + '/' + c.basename.to_s, deep))
        end
      end
      _hash
    end
end