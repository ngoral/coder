module CleanHelpers
  module ClassMethods
    def encoding(encoding, &block)
      return unless described_class.supports? encoding
      context(encoding) do
        let(:encoding) { encoding }
        subject { described_class.new(encoding) }
        instance_eval(&block)
      end
    end

    def cleans(from, to = from)
      it "cleans #{from.inspect} to #{to.inspect}" do
        subject.clean(from).should binary_equal(to)
      end
    end

    def sets_encoding
      return unless ''.respond_to? :encoding
      it 'sets encoding properly' do
        subject.clean(''.encode('US-ASCII')).encoding.names.should include(encoding)
      end
    end
  end

  def support(encoding)
    be_supports(encoding)
  end

  def self.append_features(obj)
    obj.extend ClassMethods
    obj.subject { obj.described_class }
    super
  end
end