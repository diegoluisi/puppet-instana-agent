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

# This fact is a simple wrapper to find out whether the system runs on systemd
# or not. Call it via `$facts['is_systemd']`.

Facter.add(:is_systemd) do
  setcode do
    (`ps --no-headers -o comm 1` == 'systemd')
  end
end
