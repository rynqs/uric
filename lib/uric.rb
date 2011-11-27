require 'addressable/uri'
require 'mime/types'
require 'hpricot'
require 'open-uri'
require 'yaml'

module Uric
  class URI
    attr_accessor :path, :dic
    def initialize(uri='')
      @path = uri
      dic_load
    end

    def host_origin 
      @host_origin = Addressable::URI.parse(@path).host.to_s
    end

    def file_origin
      @file_origin = MIME::Types.type_for(@path)[0].to_s
    end

    def host
      if @dic["hosts"].has_key?(@host_origin)
        @dic["hosts"][@host_origin] 
      else 
        @hots_origin 
      end
    end

    def file
      if @dic["types"].has_key?(@file_origin)
        @dic["types"][@file_origin]
      else
        @file_origin
      end
    end

    def title
      begin
        doc = Hpricot(open(@path))
        @title = doc.search('title').text
      rescue => e
        STDERR.puts e
      rescue Timeout::Error => e
        STDERR.puts e
      end
    end
    
    def add_host_alias(key, value)
      add_alias(key, value, "hosts")
    end

    def add_type_alias(key, value)
      add_alias(key, value, "types")
    end

    def add_alias(key, value, category)
      unless @dic[category].has_key?(key)
        @dic[category].store(key, value)
        dic_reload
      end
    end

    def dic_load
      @dic = YAML.load_file('lib/aliases.yml')
    end

    def dic_save
      open('lib/aliases.yml', 'w') do |f|
        f.write(YAML.dump(@dic))
      end
    end
      
    def dic_reload
      dic_save
      dic_load
    end
  end
end

if __FILE__ == $0
  include Uric
  rl = Uric::URI.new
  p rl.host_origin
  p rl.file_origin
  p rl.host
  p rl.file
  p rl.title
  p rl.dic
  p rl.add_host_alias("test.url", "TestUrl")
  p rl.add_type_alias("text/xml", "XML")
end 
