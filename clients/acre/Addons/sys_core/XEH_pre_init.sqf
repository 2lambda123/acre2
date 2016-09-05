/*
    Copyright © 2016,International Development & Integration Systems, LLC
    All rights reserved.
    http://www.idi-systems.com/

    For personal use only. Military or commercial use is STRICTLY
    prohibited. Redistribution or modification of source code is
    STRICTLY prohibited.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
    COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES INCLUDING,
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.
*/
#include "script_component.hpp"

NO_DEDICATED;
ADDON = false;

PREP(addKeyHandlerFromConfig);
PREP(addLanguageType);
PREP(aliveMonitor);
PREP(callExt);
PREP(canUnderstand);
PREP(cycleLanguage);
PREP(delayFrame);
PREP(delayFramePFH);
PREP(findOcclusion);
PREP(getAlive);
PREP(getClientIdLoop);
PREP(getHeadVector);
PREP(getLanguageId);
PREP(getLanguageName);
PREP(getSpeakingLanguageId);
PREP(getSpokenLanguages);
PREP(handleGetClientID);
PREP(handleGetHeadVector);
PREP(handleGetPluginVersion);
PREP(handleMultiPttKeyPress);
PREP(handleMultiPttKeyPressUp);
PREP(interactMenu_deadMenu);
PREP(interactMenu);
PREP(intToStr);
PREP(isMuted);
PREP(keyboardEvent);
PREP(loadConfig);
PREP(localStartSpeaking);
PREP(localStopSpeaking);
PREP(moveLips);
PREP(muting);
PREP(onPlayerKilled);
PREP(parseIni);
PREP(pong);
PREP(processDirectSpeaker);
PREP(processRadioSpeaker);
PREP(remoteStartSpeaking);
PREP(remoteStopSpeaking);
PREP(setSpeakingLanguage);
PREP(setSpokenLanguages);
PREP(showBroadCastHint);
PREP(speaking);
PREP(spectatorOff);
PREP(spectatorOn);
PREP(switchChannelFast);
PREP(switchRadioEar);
PREP(toggleHeadset);
PREP(ts3idToPlayer);
PREP(updateSelf);
PREP(utilityFunction);

PREP(disableRevealAI);
PREP(enableRevealAI);
PREP(onRevealUnit);

/**
*
*
*
*/
DGVAR(spect_muteDead) = false;
DGVAR(spect_muteAlive) = false;
PREP(interactMenu_deadMenu_actions);

// globals
DGVAR(lowered) = 0;
DGVAR(muting) = [];
DGVAR(speakers) = [];
DGVAR(ts3id) = -1;
DGVAR(keyedMicRadios) = [];
DGVAR(keyedRadioIds) = HASH_CREATE;
DGVAR(globalVolume) = 1.0;
DGVAR(maxVolume) = 1.0;
DGVAR(playerList) = []; // Paired array: [TS_ID, Object]
//DGVAR(ts3IdPlayerList) = [];
DGVAR(isDeaf) = false;
//DGVAR(playerListHash) = HASH_CREATE;
DGVAR(spectatorSpeakers) = [];

DGVAR(threadedExtCalls) = [];

DGVAR(nearRadios) = [];

DGVAR(pttKeyDown) = false;

DGVAR(keyboardEventsDown) = HASH_CREATE;
DGVAR(keyboardEventsUp) = HASH_CREATE;
DGVAR(keyboardEvents) = HASH_CREATE;

DGVAR(speaking_cache_valid) = false;

DVAR(ACRE_SPIT_VERSION) = false;
DVAR(ACRE_IS_SYNCING) = false;
DVAR(ACRE_SPECTATORS_LIST) = [];
DVAR(ACRE_HAS_WARNED) = false;

DVAR(ACRE_LOCAL_BROADCASTING) = false;
DVAR(ACRE_LOCAL_SPEAKING) = false;
DVAR(ACRE_SPECTATOR_VOLUME) = 1;

DVAR(ACRE_MUTE_SPECTATORS) = false;
DVAR(ACRE_CORE_INIT) = false;

DVAR(ACRE_VOICE_CURVE_MODEL) = ACRE_CURVE_MODEL_SELECTABLE_B;
DVAR(ACRE_VOICE_CURVE_SCALE) = 1.0;

DVAR(ACRE_LISTENER_POS) = [0,0,0];
DVAR(ACRE_LISTENER_DIR) = [0,1,0];

DVAR(ACRE_PTT_RELEASE_DELAY) = 0.2;
DVAR(ACRE_ASSIGNED_PTT_RADIOS) = [];
GVAR(delayReleasePTT_Handle) = nil;

// DVAR(ACRE_USE_DEBUG_EXTENSIONS) = true;

DVAR(ACRE_ACTIVE_PTTKEY) = -2;
DVAR(ACRE_BROADCASTING_RADIOID) = "";

DVAR(ACRE_CURRENT_LANGUAGE_ID) = 0;
DVAR(ACRE_SPOKEN_LANGUAGES) = [];

DVAR(ACRE_AI_ENABLED) = true;
DGVAR(monitorAIHandle) = -1;

DVAR(ACRE_FULL_DUPLEX) = false;
DVAR(ACRE_INTERFERENCE) = true;

DGVAR(languages) = [];

DVAR(ACRE_TEST_OCCLUSION) = true;
DVAR(ACRE_SIGNAL_DEBUGGING) = 0;

acre_player = player;

GVAR(coreCache) = HASH_CREATE;

acre_sys_io_ioEventFnc = {
    BEGIN_COUNTER(ioEventFunction);
    _this call EFUNC(sys_rpc,handleData);
    END_COUNTER(ioEventFunction);
};

_acrePlayerFnc = {
    acre_player = missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit", player];
    /*if(cameraOn != acre_player) then {
        if(lifeState cameraOn != "") then {
            acre_player = cameraOn;
        };
    };*/
};
ADDPFH(_acrePlayerFnc, 0, []);

#ifdef USE_DEBUG_EXTENSIONS
"acre_dynload" callExtension format["load:%1", "idi\build\win32\Debug\acre.dll"];
#endif

DFUNC(formatNumber) = {
    private _ext = abs _this - (floor abs _this);
    private _str = "";

    for "_i" from 1 to 24 do {
        private _d = floor (_ext*10);
        _str = _str + (str _d);
        _ext = (_ext*10)-_d;
    };
    format["%1%2.%3", ["","-"] select (_this < 0), (floor (abs _this)), _str];
};

_monitorFnc = {
    _res = ["fetch_result", ""] call FUNC(callExt);
    while {!isNil "_res"} do {
        // diag_log text format["RES: %1", _res];
        _id = _res select 0;
        _callBack = GVAR(threadedExtCalls) select _id;
        if(IS_ARRAY(_callBack)) then {
            _args = (_res select 1);
            if(count _args > 0) then {
                _args = _args select 0;
            };
            [_callBack select 0, _args] call (_callBack select 1);
        };
        _res = ["fetch_result", ""] call FUNC(callExt);
    };
};
ADDPFH(_monitorFnc, 0, []);

ACRE_TESTANGLES = [];
_m = 8;
_spread = 75;
for "_i" from 1 to (_m/2) do {
    _positive = (_spread/_m)*_i;
    _negative = ((_spread/_m)*_i)*-1;
    PUSH(ACRE_TESTANGLES, _positive);
    if(_positive != _negative) then {
        PUSH(ACRE_TESTANGLES, _negative);
    };
};

ADDON = true;
