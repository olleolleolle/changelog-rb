require 'spec_helper'

RSpec.describe Changelog::Print do
  let(:printer) {
    Changelog::Print.new.tap do |i|
      allow(i.shell).to receive(:mute?).and_return(true)
    end
  }

  it 'prints to CHANGELOG.md according to ./changelog' do
    FileUtils.cp_r("#{fixture_path}/changelog-1", 'changelog')
    printer.go
    expect(File).to exist('CHANGELOG.md')
    expect(File.read('CHANGELOG.md')).to eq(File.read("#{fixture_path}/CHANGELOG-1.md"))
  end
end
