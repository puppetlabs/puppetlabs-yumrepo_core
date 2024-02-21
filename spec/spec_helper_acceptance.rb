require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/module_install_helper'
require 'beaker/puppet_install_helper'
require 'voxpupuli/acceptance/spec_helper_acceptance'

$LOAD_PATH << File.join(__dir__, 'acceptance/lib')

hosts.each { |host| host[:type] = 'aio' }
run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

RSpec.configure do |c|
  c.before :suite do
    install_module
    install_module_dependencies
  end
end
