require 'addressable/uri'
require File.dirname(__FILE__) + '/../test_helper.rb'

class Detour::HTMLFilterTest < Test::Unit::TestCase
  context "#replace" do
    should "replace hrefs" do
      text = "<a href=\"http://yahoo.com\">Yahoo</a>"
      filter = Detour::HTMLFilter.new(text)
      filter.replace { "foo" }
      assert_equal "<a href=\"foo\">Yahoo</a>", filter.content
    end

    should "handle cases when there is no href attribute" do
      text = "<a>Yahoo</a>"
      filter = Detour::HTMLFilter.new(text)
      filter.replace { "foo" }
      assert_equal "<a>Yahoo</a>", filter.content
    end
  end

  context "#auto_link" do
    should "convert plain URLs into links" do
      text = "Hello http://www.google.com."
      filter = Detour::HTMLFilter.new(text)
      filter.auto_link
      assert_equal "Hello <a href=\"http://www.google.com\">http://www.google.com</a>.", filter.content
    end

    should "not replace urls inside a-tags" do      
      text = "<a href=\"http://yahoo.com\">http://yahoo.com</a>"
      filter = Detour::HTMLFilter.new(text)
      filter.auto_link
      assert_equal text, filter.content
    end
  end

  context "#build_anchor_tag" do
    should "use the right text and href" do
      filter = Detour::HTMLFilter.new("")
      tag = "<a href=\"http://www.google.com\">Google</a>"
      assert_equal tag, filter.build_anchor_tag("Google", "http://www.google.com")
    end
    
    should "include additional attributes" do
      filter = Detour::HTMLFilter.new("")
      tag = "<a href=\"http://www.google.com\" class=\"button\">Google</a>"
      assert_equal tag, filter.build_anchor_tag("Google", "http://www.google.com", :class => "button")
    end
  end

  context "#content" do
    should "cast parsed content to string" do
      filter = Detour::HTMLFilter.new("")
      filter.expects(:parsed_content).returns(stub(:to_s => "bar"))
      assert_equal "bar", filter.content
    end
  end
end