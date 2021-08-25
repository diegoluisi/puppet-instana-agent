#
# Author:: Stefan Staudenmeyer <stefan.staudenmeyer@instana.com>
# Module Name:: instana_agent
#
# Copyright 2017, Instana, Inc.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# = Define: instana_agent::install
#
# Installs the repository + package of the Instana Agent.
#

class instana_agent::install {
  $pkg_src   = "https://_:${$instana_agent::instana_agent_key}@packages.instana.io/agent"
  $family    = downcase($facts['os']['family'])

  if ($family == 'debian') {

    #package { 'apt-transport-https':
    #  ensure   => 'installed',
    #  provider => 'apt',
    #}

    include ::apt

    apt::key { 'puppetlabs':
      ensure => 'present',
      id     => 'B878152E2F084D46F878FA20BED2D0969BAD82DE',
      source => 'https://packages.instana.io/Instana.gpg',
    }

    apt::source { 'instana-agent':
      ensure       => 'present',
      architecture => 'amd64',
      include      => {
        'src' => false,
        'deb' => true,
      },
      location     => $pkg_src,
      release      => 'generic',
      repos        => 'main',
      require      => Package['apt-transport-https']
    }
    Apt::Source['instana-agent']
      ~> Package["instana-agent-${$instana_agent::instana_agent_flavor}"]
  }

  if ($family == 'suse') {
    exec { 'import gpg key':
      command => '/bin/rpm --import https://packages.instana.io/Instana.gpg',
      unless  => '/bin/rpm -q gpg-pubkey | grep gpg-pubkey-9bad82de-574bdebd ',
    }

    zypprepo { 'Instana-Agent':
      baseurl  => "${$pkg_src}/generic/x86_64",
      enabled  => 1,
      name     => 'Instana-Agent',
      gpgkey   => 'https://packages.instana.io/Instana.gpg',
      gpgcheck => 1,
      type     => 'rpm-md',
      require  => Exec['import gpg key'],
    }
    Zypprepo['Instana-Agent']
      ~> Package["instana-agent-${$instana_agent::instana_agent_flavor}"]
  }

  if ($family == 'redhat') {
    yumrepo { 'Instana-Agent':
      ensure        => 'present',
      assumeyes     => true,
      baseurl       => "${$pkg_src}/generic/x86_64",
      enabled       => true,
      gpgkey        => 'https://packages.instana.io/Instana.gpg',
      gpgcheck      => true,
      repo_gpgcheck => true,
      sslverify     => true,
    }
    Yumrepo['Instana-Agent']
      ~> Package["instana-agent-${$instana_agent::instana_agent_flavor}"]
  }

  package { "instana-agent-${$instana_agent::instana_agent_flavor}":
    ensure => installed,
  }
}
