
# yumrepo_core

[![Modules Status](https://github.com/puppetlabs/puppetlabs-yumrepo_core/workflows/%5BDaily%5D%20Unit%20Tests%20with%20nightly%20Puppet%20gem/badge.svg?branch=main)](https://github.com/puppetlabs/puppetlabs-yumrepo_core/actions)
[![Modules Status](https://github.com/puppetlabs/puppetlabs-yumrepo_core/workflows/Static%20Code%20Analysis/badge.svg?branch=main)](https://github.com/puppetlabs/puppetlabs-yumrepo_core/actions) 
[![Modules Status](https://github.com/puppetlabs/puppetlabs-yumrepo_core/workflows/Unit%20Tests%20with%20nightly%20Puppet%20gem/badge.svg?branch=main)](https://github.com/puppetlabs/puppetlabs-yumrepo_core/actions) 
[![Modules Status](https://github.com/puppetlabs/puppetlabs-yumrepo_core/workflows/Unit%20Tests%20with%20released%20Puppet%20gem/badge.svg?branch=main)](https://github.com/puppetlabs/puppetlabs-yumrepo_core/actions)


#### Table of Contents

1. [Description](#description)
2. [Usage - Configuration options and additional functionality](#usage)
3. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
4. [Development - Guide for contributing to the module](#development)

<a id="description"></a>
## Description

The yumrepo_core module is used to manage client yum repo configurations by parsing INI configuration files.

<a id="usage"></a>
## Usage

To manage a yum repo for Puppet Labs Products while using a local mirror, use the following code:

```
yumrepo { 'puppetrepo-products':
  ensure    => 'present',
  name      => 'puppetrepo-products',
  descr     => 'Puppet Labs Products El 7 - $basearch',
  baseurl   => 'http://myownmirror',
  gpgkey    => 'http://myownmirror',
  enabled   => '1',
  gpgcheck  => '1',
  target    => '/etc/yum.repos.d/puppetlabs.repo',
}

```

<a id="reference"></a>
## Reference

Please see REFERENCE.md for the reference documentation.

This module is documented using Puppet Strings.

For a quick primer on how Strings works, please see [this blog post](https://puppet.com/blog/using-puppet-strings-generate-great-documentation-puppet-modules) or the [README.md](https://github.com/puppetlabs/puppet-strings/blob/master/README.md) for Puppet Strings.

To generate documentation locally, run the following command:
```
bundle install
bundle exec puppet strings generate ./lib/**/*.rb
```
This command will create a browsable `_index.html` file in the `doc` directory. The references available here are all generated from YARD-style comments embedded in the code base. When any development happens on this module, the impacted documentation should also be updated.

<a id="development"></a>
## Development

Puppet Labs modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. We can't access the huge number of platforms and myriad of hardware, software, and deployment configurations that Puppet is intended to serve.

We want to keep it as easy as possible to contribute changes so that our modules work in your environment. There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things.

For more information, see our [module contribution guide.](https://puppet.com/docs/puppet/latest/contributing.html)
