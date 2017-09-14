require 'spec_helper'
require 'yaml'

RSpec.describe Changelog::Add do
  let(:add) {
    Changelog::Add.new.tap do |i|
      allow(i.shell).to receive(:mute?).and_return(true)
    end
  }

  it 'creates directory ./changelog/unreleased if it does not exist' do
    expect(File).not_to exist('changelog/unreleased')
    add.go('Something', 'Added', 'someone')
    expect(File).to exist('changelog/unreleased')
  end

  it 'generates the YAML file for the changelog item and add to ./changelog/unreleased' do
    add.go('Added command for adding changelog item', 'Added', 'someone')
    expect(File).to exist('changelog/unreleased/added_command_for_adding_changelog_item.yml')

    yaml = YAML.load_file('changelog/unreleased/added_command_for_adding_changelog_item.yml')
    expect(yaml['type']).to eq('Added')
    expect(yaml['title']).to eq("Added command for adding changelog item\n")
    expect(yaml['author']).to eq('someone')
  end

  it 'guesses nature from title' do
    add.go('Added command for adding changelog item', '', 'someone')

    yaml = YAML.load_file('changelog/unreleased/added_command_for_adding_changelog_item.yml')
    expect(yaml['type']).to eq('Added')
  end

  it 'guesses author from system' do
    expect(Changelog::Helpers::Shell).to receive(:system_user).and_return('someone')

    add.go('Added command for adding changelog item')

    yaml = YAML.load_file('changelog/unreleased/added_command_for_adding_changelog_item.yml')
    expect(yaml['author']).to eq('someone')
  end

  it 'raises error if title is not blank' do
    expect {
      add.go('')
    }.to raise_error('title is blank')
  end

  it 'raises error if nature is not defined' do
    expect {
      add.go('I love changelog')
    }.to raise_error('nature is blank')
  end

  it 'raises error if nature is not defined' do
    expect {
      add.go('I love changelog', 'Modified')
    }.to raise_error('nature is invalid')
  end
end