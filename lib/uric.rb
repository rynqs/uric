require 'addressable/uri'
require 'mime/types'
require 'yaml'
require 'mechanize'

module Uric
  class URI
    attr_accessor :path, :dic
    @@dic = []
    def initialize(uri='')
      @path = uri
      dic_load
    end

    def host_origin 
      Addressable::URI.parse(@path).host.to_s
    end

    def type_origin
      MIME::Types.type_for(@path)[0].to_s
    end

    def host
      if @dic['hosts'].has_key?(self.host_origin)
        @dic['hosts'][self.host_origin].to_s 
      else 
        self.host_origin 
      end
    end

    def type
      if @dic['types'].has_key?(self.type_origin)
        @dic['types'][self.type_origin].to_s
      else
        self.type_origin
      end
    end

    def title
      begin
        agent = Mechanize.new
        @title = agent.get(Addressable::URI.parse(@path).normalize).title
      rescue => e
        STDERR.puts e
      rescue Timeout::Error => e
        STDERR.puts e
      end
    end
    
    def add_host_alias(key, value)
      add_alias(key, value, 'hosts')
    end

    def add_type_alias(key, value)
      add_alias(key, value, 'types')
    end

    def add_alias(key, value, category)
      unless @dic[category].has_key?(key)
        @dic[category].store(key, value)
        dic_reload
      else
        @dic[category][key] = value
      end
      dic_reload
      @dic[category][key]
    end

    def remove_host_alias(key)
      remove_alias(key, 'hosts')
    end

    def remove_type_alias(key)
      remove_alias(key, 'types')
    end

    def remove_alias(key, category)
      if @dic[category].has_key?(key)
        @dic[category].delete(key)
        dic_reload
      end
    end

    def dic_load
      @dic = YAML.load_file(File.join(File.dirname(__FILE__), 'aliases.yml'))
    end

    def dic_save
      open(File.join(File.dirname(__FILE__), 'aliases.yml'), 'w') do |f|
        f.write(YAML.dump(@dic))
      end
    end
      
    def dic_reload
      dic_save
      dic_load
    end
  end
end

