require "./after_sending"
require "test/unit"

class StatefulThing
  attr_accessor :state
  def initialize
    @state = false
  end
  def become_true!
    @state = true
  end
end

class TestAfterSending < Test::Unit::TestCase
  def test
    a = StatefulThing.new.after_sending.become_true!
    b = StatefulThing.new.after_sending{become_true!}

    [a,b].each do |t|
      assert t.state
      assert_equal t.class, StatefulThing
    end
  end
end
