require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/module_install_helper'
require 'voxpupuli/acceptance/spec_helper_acceptance'

$LOAD_PATH << File.join(__dir__, 'acceptance/lib')
def run_puppet_install_helper
  return unless ENV['PUPPET_INSTALL_TYPE'] == 'agent'
  if ENV['BEAKER_PUPPET_COLLECTION'].match? %r{/-nightly$/}
    # Workaround for RE-10734
    options[:release_apt_repo_url] = 'http://nightlies.puppet.com/apt'
    options[:win_download_url] = 'http://nightlies.puppet.com/downloads/windows'
    options[:mac_download_url] = 'http://nightlies.puppet.com/downloads/mac'
  end

  agent_sha = ENV['BEAKER_PUPPET_AGENT_SHA'] || ENV['PUPPET_AGENT_SHA']
  if agent_sha.nil? || agent_sha.empty?
    install_puppet_agent_on(hosts, options.merge(version: version))
  else
    # If we have a development sha, assume we're testing internally
    dev_builds_url = ENV['DEV_BUILDS_URL'] || 'http://builds.delivery.puppetlabs.net'
    install_from_build_data_url('puppet-agent', "#{dev_builds_url}/puppet-agent/#{agent_sha}/artifacts/#{agent_sha}.yaml", hosts)
  end

  # XXX install_puppet_agent_on() will only add_aio_defaults_on when the
  # nodeset type == 'aio', but we don't want to depend on that.
  add_aio_defaults_on(hosts)
  add_puppet_paths_on(hosts)
end

hosts.each { |host| host[:type] = 'aio' }
run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

RSpec.configure do |c|
  c.before :suite do
    install_module
    install_module_dependencies
  end
end
