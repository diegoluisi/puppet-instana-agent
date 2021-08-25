require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'metadata-json-lint/rake_task'
require 'puppet-lint/tasks/puppet-lint'
# require 'rspec-puppet'
# require 'rspec-puppet-facts'

# include RspecPuppetFacts

RuboCop::RakeTask.new
# RSpec::Core::RakeTask.new(:spec)
PuppetLint.configuration.send('disable_autoloader_layout')

task default: %i[rubocop metadata_lint lint]
# task default: %i[rubocop metadata_lint spec lint]
