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

# = Define: instana_agent::config
#
# Optional agent configuration.
#

class instana_agent::config {

  require instana_agent::required_config

  $dir = '/opt/instana/agent/etc/instana/'

  if ($instana_agent::instana_agent_flavor != 'static' and
    $instana_agent::instana_agent_update_enabled) {
    $update_string = 'AUTO'
  } else {
    $update_string = 'OFF'
  }

  file { "${$dir}configuration.yaml":
    ensure  => 'file',
    content => epp('instana_agent/agent_configuration.epp', {
      'tags'       => $instana_agent::instana_agent_tags,
      'zone'       => $instana_agent::instana_agent_zone,
      'plugin_php' => $instana_agent::instana_agent_plugin_php,
    }),
    group   => 'root',
    mode    => '0640',
    owner   => 'root',
    notify  => Service['instana-agent'],
  }

#  file_line { 'ensure agent mode':
#    ensure => present,
#    match  => '^mode\=',
#    path   => "${$dir}com.instana.agent.main.config.Agent.cfg",
#    line   => "mode=${upcase($instana_agent::instana_agent_mode)}",
#    notify => Service['instana-agent'],
#  }

  file { "${$dir}com.instana.agent.main.config.Agent.cfg":
    ensure  => 'file',
    content => epp('instana_agent/agent_main_config.epp', {
      'agent_mode' => $instana_agent::instana_agent_mode,
    }),
    group   => 'root',
    mode    => '0640',
    owner   => 'root',
    notify  => Service['instana-agent'],
  }

  file { "${$dir}com.instana.agent.main.config.UpdateManager.cfg":
    ensure  => 'file',
    content => epp('instana_agent/agent_updates.epp', {
      'update_enabled'  => $update_string,
      'update_interval' => $instana_agent::instana_agent_update_interval,
      'update_time'     => $instana_agent::instana_agent_update_time,
    }),
    group   => 'root',
    mode    => '0640',
    owner   => 'root',
  }

  file { "${$dir}com.instana.agent.bootstrap.AgentBootstrap.cfg":
    ensure  => 'file',
    content => epp('instana_agent/agent_sensorpin.epp', {
      'version' => $instana_agent::instana_agent_update_pin
    }),
    group   => 'root',
    mode    => '0640',
    owner   => 'root',
  }
}
