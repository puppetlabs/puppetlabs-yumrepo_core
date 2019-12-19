require 'spec_helper_acceptance'

# The target parameter doesn't work (see PUP-2782) so this creates two
# files instead of two repo entries in the one target file
products_repo = '/etc/yum.repos.d/puppetrepo-products.repo'
deps_repo = '/etc/yum.repos.d/puppetrepo-deps.repo'
manifest = <<MANIFEST
yumrepo {'puppetrepo-products':
  name      => 'puppetrepo-products',
  descr     => 'Puppet Labs Products El 7 - $basearch',
  ensure    => 'present',
  baseurl   => 'http://myownmirror',
  gpgkey    => 'http://myownmirror',
  enabled   => '1',
  gpgcheck  => '1',
  target    => '/etc/yum.repo.d/puppetlabs.repo',
}
yumrepo{'puppetrepo-deps':
  name      => 'puppetrepo-deps',
  descr     => 'Puppet Labs Dependencies El 7 - $basearch',
  ensure    => 'present',
  baseurl   => 'http://myownmirror',
  gpgkey    => 'http://myownmirror',
  enabled   => '1',
  gpgcheck  => '1',
  target    => '/etc/yum.repo.d/puppetlabs.repo',
}
MANIFEST

def resource(host, type, name)
  on(host, puppet("resource -y #{type} #{name}")) do |result|
    yaml = YAML.safe_load(result.stdout)
    yield yaml[type][name]
  end
end

RSpec.context 'Manages yumrepo' do
  agents.each do |agent|
    it 'creates multiple yum repo files' do
      apply_manifest_on(agent, manifest)

      [products_repo, deps_repo].each do |repo|
        resource(agent, 'file', repo) do |res|
          assert_equal(res['ensure'], 'file')
          assert_equal(res['mode'], '0644')
        end
      end
    end

    it 'removes a yumrepo entry' do
      apply_manifest_on(agent, <<ABSENT)
yumrepo{'puppetrepo-deps':
  name      => 'puppetrepo-deps',
  ensure    => 'absent',
  target    => '/etc/yum.repo.d/puppetlabs.repo',
}
ABSENT
      resource(agent, 'file', deps_repo) do |res|
        # absent removes the entry, leaving an empty file with a known checksum
        assert_equal(res['ensure'], 'file')
        assert_equal(res['content'], '{md5}d41d8cd98f00b204e9800998ecf8427e')
      end
    end

    it 'updates a yumrepo entry' do
      apply_manifest_on(agent, manifest)
      apply_manifest_on(agent, <<UPDATED)
yumrepo {'puppetrepo-products':
  ensure    => 'present',
  enabled   => 'no',
  baseurl   => 'http://myothermirror',
  gpgkey    => 'http://myothermirror',
  priority  => '99',
  retries   => '11',
  timeout   => '2000',
}
UPDATED
      on(agent, "grep enabled=No #{products_repo}") # booleans are special
      on(agent, "grep baseurl=http://myothermirror #{products_repo}")
      on(agent, "grep gpgkey=http://myothermirror #{products_repo}")
      on(agent, "grep priority=99 #{products_repo}")
      on(agent, "grep retries=11 #{products_repo}")
      on(agent, "grep timeout=2000 #{products_repo}")
    end

    it 'discovers yumrepos' do
      resource(agent, 'yumrepo', 'puppetrepo-products') do |res|
        # verify some basic info
        assert_match(res['ensure'], 'present')
        assert_match(res['descr'], 'Puppet Labs Products El 7 - $basearch')
      end
    end

    describe '`proxy` property' do
      context 'when set to a URL' do
        it 'applies idempotently' do
          pp = <<-MANIFEST
          yumrepo {'proxied-repo':
            baseurl => 'http://myownmirror',
            proxy   => 'http://proxy.example.com:3128',
          }
          MANIFEST

          apply_manifest(pp, catch_failures: true)
          apply_manifest(pp, catch_changes: true)
        end

        describe file('/etc/yum.repos.d/proxied-repo.repo') do
          its(:content) { is_expected.to contain('proxy=http://proxy.example.com:3128') }
        end
      end
      context 'when set to `absent`' do
        it 'applies idempotently' do
          pp = <<-MANIFEST
          yumrepo {'proxied-repo':
            baseurl => 'http://myownmirror',
            proxy   => absent,
          }
          MANIFEST

          apply_manifest(pp, catch_failures: true)
          apply_manifest(pp, catch_changes: true)
        end

        describe file('/etc/yum.repos.d/proxied-repo.repo') do
          its(:content) { is_expected.not_to contain('proxy') }
        end
      end
      context 'when set to `_none_`' do
        it 'applies idempotently' do
          pp = <<-MANIFEST
          yumrepo {'proxied-repo':
            baseurl => 'http://myownmirror',
            proxy   => '_none_',
          }
          MANIFEST

          apply_manifest(pp, catch_failures: true)
          apply_manifest(pp, catch_changes: true)
        end

        if fact('os.release.major').to_i >= 8
          describe file('/etc/yum.repos.d/proxied-repo.repo') do
            its(:content) { is_expected.to match(%r{^proxy=$}) }
          end
        else
          describe file('/etc/yum.repos.d/proxied-repo.repo') do
            its(:content) { is_expected.to match(%r{^proxy=_none_$}) }
          end
        end
      end
    end
  end
end
