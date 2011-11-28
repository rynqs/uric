require 'helper'
require 'uric'
require 'kconv'
# -*- encoding: utf-8 -*-

class TestUric < Test::Unit::TestCase
  def setup
    @pdf = Uric::URI.new('http://manuals.info.apple.com/ja_JP/Enterprise_Deployment_Guide_J.pdf')
    @ruby = Uric::URI.new('http://www.ruby-lang.org/ja/')
  end

  def test_dic
    assert_not_nil(@pdf.dic)
  end

  def test_object
    assert_not_nil(@pdf)
    assert_not_nil(@ruby)
  end

  def test_host_origin
    assert_equal('manuals.info.apple.com', @pdf.host_origin)
  end
  
  def test_type_origin
    assert_equal('application/pdf', @pdf.type_origin)
  end

  def test_host
    assert_equal('Apple', @pdf.host)
  end

  def test_type
    assert_equal('PDF', @pdf.type)
  end

  def test_title
    assert_not_nil(@pdf.title)
    assert_not_nil(@ruby.title)
    #assert_equal('', @ruby.title)
  end

  def test_host_alias
    assert_equal('TEST', @pdf.add_host_alias('test.co.jp', 'TEST'))
    @pdf.remove_host_alias('test.co.jp')
    assert(@pdf.dic['hosts'].has_key?('test.co.jp') == false)
  end

  def test_type_alias
    assert_equal('HOGE', @pdf.add_type_alias('test/hoge', 'HOGE'))
    @pdf.remove_type_alias('test/hoge')
    assert(@pdf.dic['types'].has_key?('test/hoge') == false)
  end
end
