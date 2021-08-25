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

# = Define: instana_agent::default
#
# Safeguards and bootstrapping the module.
#

class instana_agent(
  String        $instana_agent_key                  = '',
  String        $instana_agent_endpoint_host        = 'saas-us-west-2.instana.io',
  Numeric       $instana_agent_endpoint_port        = 443,
  String        $instana_agent_flavor               = 'static',
  String        $instana_agent_mode                 = 'APM',
  Array[String] $instana_agent_tags                 = [],
  String        $instana_agent_zone                 = '',
  String        $instana_agent_update_pin           = '',
  Boolean       $instana_agent_update_enabled       = true,
  String        $instana_agent_update_interval      = 'DAY',
  String        $instana_agent_update_time          = '04:30',
  Boolean       $instana_agent_cpu_limited          = true,
  Float         $instana_agent_cpu_quota            = 0.5,
  Boolean       $instana_agent_memory_limited       = true,
  Numeric       $instana_agent_memory_quota         = 512,
  Boolean       $instana_agent_proxy_enabled        = false,
  String        $instana_agent_proxy_type           = 'http',
  String        $instana_agent_proxy_host           = '',
  Numeric       $instana_agent_proxy_port           = 3128,
  Boolean       $instana_agent_proxy_dns            = true,
  String        $instana_agent_proxy_username       = '',
  String        $instana_agent_proxy_password       = '',
  Boolean       $instana_agent_mirror_enabled       = false,
  Boolean       $instana_agent_mirror_auth_enabled  = false,
  String        $instana_agent_mirror_auth_username = '',
  String        $instana_agent_mirror_auth_password = '',
  String        $instana_agent_mirror_urls_release  = '',
  String        $instana_agent_mirror_urls_shared   = '',
  Boolean       $instana_agent_plugin_php           = false,
) {

  if ($instana_agent_key == '') {
    fail('Instana Agent configuration misses an agent key!')
  }

  if ($instana_agent_endpoint_host == '') {
    fail('Instana Agent configuration misses an agent endpoint host address!')
  }

  if ($instana_agent_endpoint_port <= 0) {
    fail('Instana Agent configuration misses an agent endpoint host port!')
  }

  $valid_types = ['dynamic', 'static']
  if (!$instana_agent_flavor in $valid_types) {
    fail('Instana Agent configuration flavor is invalid!')
  }

  require instana_agent::config

  service { 'instana-agent':
    ensure  => 'running',
  }
}
