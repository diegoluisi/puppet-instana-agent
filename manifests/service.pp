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

# = Define: instana_agent::service
#
# Bootstrap the system service, configure details as needed.
#

class instana_agent::service {

  require instana_agent::install

  $dir = '/etc/systemd/system/instana-agent.service.d'

  if ($facts['is_systemd']) {
    file { $dir:
      ensure => 'directory',
      group  => 'root',
      mode   => '0750',
      owner  => 'root',
    }

    if ($instana_agent::instana_agent_cpu_limited or $instana_agent::instana_agent_memory_limited) {

      $resource_template = @("EOT")
        [Service]
        <% if ${$instana_agent::instana_agent_cpu_limited} { -%>CPUAccounting=true
        CPUQuota=<%= ( ${$instana_agent::instana_agent_cpu_quota} * 100 ) %>%
        <% } -%>
        <% if ${$instana_agent::instana_agent_memory_limited} { -%>MemoryAccounting=true
        MemoryMax=<%= ${$instana_agent::instana_agent_memory_quota} %>
        <% } -%>
      | EOT

      file { "${$dir}/10-resources.conf":
        ensure  => 'file',
        content => "[Service]\n${$resource_template}",
        group   => 'root',
        mode    => '0640',
        owner   => 'root',
      }
    }
  }
}
