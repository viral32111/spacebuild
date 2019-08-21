# Spacebuild

This is a modification of the popular [Spacebuild 3](https://github.com/spacebuild/spacebuild) addon for Garry's Mod made fit for the Conspiracy Servers community.

The current changes are as follows: *(All links reference where the code was changed in the __old__ repository)*
 * Removed [addon loaded](https://github.com/spacebuild/spacebuild/blob/master/lua/autorun/client/cl_caf_autostart.lua#L254) and [support messages](https://github.com/spacebuild/spacebuild/blob/master/lua/autorun/server/sv_caf_autostart.lua#L406) in chat when a player spawns in the server.
 * Removed [server tags](https://github.com/spacebuild/spacebuild/blob/master/lua/autorun/server/sv_caf_autostart.lua#L454) since the game doesn't use them anymore.
 * Removed the [Garry-Kicker](https://github.com/spacebuild/spacebuild/blob/master/lua/autorun/server/sv_caf_autostart.lua#L401).
 * Removed included [gamemodes](https://github.com/spacebuild/spacebuild/tree/master/gamemodes/spacebuild) and [maps](https://github.com/spacebuild/spacebuild/tree/master/maps).
 * Removed [miscellaneous git files](https://github.com/spacebuild/spacebuild).
 * Removed [documentation](https://github.com/spacebuild/spacebuild/tree/master/docs).
 * Renamed the [CAF tab to Spacebuild](https://github.com/spacebuild/spacebuild/blob/master/lua/caf/core/client/cl_tab.lua#L11) on the spawnmenu.
 * Added an extra category for the link tools.
 * Enabled [Life Support entities for Sandbox](https://github.com/spacebuild/spacebuild/blob/master/lua/caf/stools/ls3_environmental_control.lua#L100).
 * Removed the entire [CAF Main Menu](https://github.com/spacebuild/spacebuild/blob/master/lua/autorun/client/cl_caf_autostart.lua#L707) and its [associated spawnmenu tab](https://github.com/spacebuild/spacebuild/blob/master/lua/autorun/client/cl_caf_autostart.lua#L740) option.
 * Removed [automatically downloaded playermodels](https://github.com/spacebuild/spacebuild/blob/master/lua/caf/addons/server/spacebuild.lua#L835).

### Copyright 2009-2016 SB Dev Team
###### Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0. Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
