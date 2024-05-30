require 'spec_helper'

RSpec.describe ActsAsSqids::Methods do
  around :context do |block|
    m = ActiveRecord::Migration.new
    m.verbose = false
    m.create_table :methods_foos, force: true do |t|
    end
    m.create_table :methods_bars, force: true do |t|
      t.string :type
    end
    begin
      block.call
    ensure
      m.drop_table :methods_foos
      m.drop_table :methods_bars
    end
  end

  def create_model(name, options = {})
    base = options[:base] || ActiveRecord::Base
    Object.send :remove_const, name if Object.const_defined?(name)
    klass = Class.new(base) do
      acts_as_sqids options
    end
    Object.const_set name, klass
    Object.const_get name
  end

  describe '.sqids_secret' do
    subject(:model) { create_model 'MethodsFoo' }

    it 'returns the class name' do
      expect(model.sqids_secret).to eq 'MethodsFoo'
    end
    context 'for STI' do
      subject(:model) { create_model 'MethodsFoo', base: MethodsBar }

      it 'returns the base class name' do
        create_model 'MethodsBar'
        expect(model.sqids_secret).to eq 'MethodsBar'
      end
    end
    context 'with custom secret' do
      subject(:model) { create_model 'MethodsFoo', secret: '^_^' }

      it 'returns the custom secret' do
        expect(model.sqids_secret).to eq '^_^'
      end
      context 'with executable secret' do
        subject(:model) { create_model 'MethodsFoo', secret: -> { "#{name} ^_^" } }

        it 'returns the custom secret' do
          expect(model.sqids_secret).to eq 'MethodsFoo ^_^'
        end
      end
    end
  end

  describe '.sqids' do
    subject(:model) { create_model 'MethodsFoo' }

    it 'returns the sqids instance' do
      expect(model.sqids.encode(1)).to eq sqids.new('MethodsFoo', 8).encode(1)
    end
    context 'with custom length' do
      subject(:model) { create_model 'MethodsFoo', length: 16 }

      it 'returns the sqids instance' do
        expect(model.sqids.encode(1)).to eq sqids.new('MethodsFoo', 16).encode(1)
      end
    end
    context 'with custom alphabet' do
      subject(:model) { create_model 'MethodsFoo', alphabet: '1234567890abcdef' }

      it 'returns the sqids instance' do
        expect(model.sqids.encode(1)).to eq sqids.new('MethodsFoo', 8, '1234567890abcdef').encode(1)
      end
    end
  end
end
