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

# = Define: instana_agent::required_config
#
# Without these the agent won't start!
#

class instana_agent::required_config {

  require instana_agent::service

  $dir = '/opt/instana/agent/etc/'

  file { "${$dir}instana/com.instana.agent.main.sender.Backend.cfg":
    ensure  => 'file',
    content => epp('instana_agent/agent_backend.epp', {
      'agent_key'      => $instana_agent::instana_agent_key,
      'endpoint_host'  => $instana_agent::instana_agent_endpoint_host,
      'endpoint_port'  => $instana_agent::instana_agent_endpoint_port,
      'proxy_enabled'  => $instana_agent::instana_agent_proxy_enabled,
      'proxy_type'     => $instana_agent::instana_agent_proxy_type,
      'proxy_host'     => $instana_agent::instana_agent_proxy_host,
      'proxy_port'     => $instana_agent::instana_agent_proxy_port,
      'proxy_dns'      => $instana_agent::instana_agent_proxy_dns,
      'proxy_username' => $instana_agent::instana_agent_proxy_username,
      'proxy_password' => $instana_agent::instana_agent_proxy_password,
    }),
    group   => 'root',
    mode    => '0640',
    owner   => 'root',
    require => Class['::instana_agent::service']
  }

  file { "${$dir}mvn-settings.xml":
    ensure  => 'file',
    content => epp('instana_agent/mvn-settings.epp', {
      'agent_key'            => $instana_agent::instana_agent_key,
      'mirrors_enabled'      => $instana_agent::instana_agent_mirror_enabled,
      'mirrors_require_auth' => $instana_agent::instana_agent_mirror_auth_enabled,
      'mirrors_username'     => $instana_agent::instana_agent_mirror_auth_username,
      'mirrors_password'     => $instana_agent::instana_agent_mirror_auth_password,
      'release_repourl'      => $instana_agent::instana_agent_mirror_urls_release,
      'shared_repourl'       => $instana_agent::instana_agent_mirror_urls_shared,
      'proxy_enabled'        => $instana_agent::instana_agent_proxy_enabled,
      'proxy_type'           => $instana_agent::instana_agent_proxy_type,
      'proxy_host'           => $instana_agent::instana_agent_proxy_host,
      'proxy_port'           => $instana_agent::instana_agent_proxy_port,
      'proxy_username'       => $instana_agent::instana_agent_proxy_username,
      'proxy_password'       => $instana_agent::instana_agent_proxy_password,
    }),
    group   => 'root',
    mode    => '0640',
    owner   => 'root',
    require => Class['::instana_agent::service']
  }

  file { "${$dir}org.ops4j.pax.url.mvn.cfg":
    ensure  => 'file',
    content => epp('instana_agent/pax-mvn-cfg.epp', {
      'flavor' => $instana_agent::instana_agent_flavor
    }),
    group   => 'root',
    mode    => '0640',
    owner   => 'root',
    require => Class['::instana_agent::service']
  }
}