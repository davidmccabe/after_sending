class Object
  # Return the receiver after sending it a message.
  #
  # Usage:
  #   class Example; def sideeffect!; puts "Hello"; end; end
  #
  #   Example.new.after_sending{ sideeffect! }
  #      Hello
  #      => "#<Example:...>"
  #
  # Questionable abbreviated usage:
  #
  #   Example.new.after_sending.sideeffect!
  #      Hello
  #      => "#<Example:...>"
  #
  # Real-world example from a unit test of a Rails model:
  #
  #   assert_equals bogus_model.after_sending{valid?}.errors[:base], "totally bogus!"
  #
  # Similar to standard Object#tap, but with a better name and better syntax,
  # since we evaluate the block with self set to the receiver, instead of
  # passing the receiver in as an argument.
  def after_sending(&block)
    if block.nil?
      AfterSender.new self
    else
      self.instance_eval &block
      self
    end
  end
end

# Helper class used by Object#after_sending. Nothing to see here.
class AfterSender
  def initialize(receiver)
    @receiver = receiver
  end
  def method_missing(name, *args, &block)
    @receiver.send name, *args, &block
    @receiver
  end
end
