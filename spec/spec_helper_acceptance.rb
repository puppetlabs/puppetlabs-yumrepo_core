require 'beaker-rspec'
require 'beaker/module_install_helper'
require 'beaker/puppet_install_helper'

$LOAD_PATH << File.join(__dir__, 'acceptance/lib')

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

RSpec.configure do |c|
  c.before :suite do
    install_module
    install_module_dependencies
  end
end
