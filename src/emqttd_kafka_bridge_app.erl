%% Copyright (c) 2018 EMQ Technologies Co., Ltd. All Rights Reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(emqttd_kafka_bridge_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    {ok, Sup} = emqttd_kafka_bridge_sup:start_link(),
    ok = emqttd_access_control:register_mod(auth, emq_auth_emqttd_kafka_bridge, []),
    ok = emqttd_access_control:register_mod(acl, emq_acl_emqttd_kafka_bridge, []),
    emqttd_kafka_bridge:load(application:get_all_env()),
    {ok, Sup}.

stop(_State) ->
    ok = emqttd_access_control:unregister_mod(auth, emq_auth_emqttd_kafka_bridge),
    ok = emqttd_access_control:unregister_mod(acl, emq_acl_emqttd_kafka_bridge),
    emqttd_kafka_bridge:unload().
