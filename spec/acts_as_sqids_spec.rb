require 'spec_helper'

describe ActsAsSqids do
  it 'has a version number' do
    expect(ActsAsSqids::VERSION).not_to be nil
  end
  it 'defines acts_as_sqids method in ActiveRecord::Base' do
    expect(ActiveRecord::Base).to respond_to(:acts_as_sqids)
  end
end
