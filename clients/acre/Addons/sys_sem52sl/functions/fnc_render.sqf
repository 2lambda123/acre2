/*
	Copyright © 2016, International Development & Integration Systems, LLC
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
#define RADIO_CTRL(var1) (_display displayCtrl var1)

params["_display"];


private _channelKnobPosition = GET_STATE(channelKnobPosition);
private _volumeKnobPosition = GET_STATE(volumeKnobPosition);

// Volume knob

private _volImages = [
	QUOTE(PATHTOF(Data\knobs\volume\vol_1000.paa)),
	QUOTE(PATHTOF(Data\knobs\volume\vol_0875.paa)),
	QUOTE(PATHTOF(Data\knobs\volume\vol_0750.paa)),
	QUOTE(PATHTOF(Data\knobs\volume\vol_0625.paa)),
	QUOTE(PATHTOF(Data\knobs\volume\vol_0500.paa)),
	QUOTE(PATHTOF(Data\knobs\volume\vol_0375.paa)),
	QUOTE(PATHTOF(Data\knobs\volume\vol_0250.paa)),
	QUOTE(PATHTOF(Data\knobs\volume\vol_0125.paa)),
	QUOTE(PATHTOF(Data\knobs\volume\vol_0000.paa)),
	QUOTE(PATHTOF(Data\knobs\volume\volsq_0125.paa)),
	QUOTE(PATHTOF(Data\knobs\volume\volsq_0250.paa)),
	QUOTE(PATHTOF(Data\knobs\volume\volsq_0375.paa)),
	QUOTE(PATHTOF(Data\knobs\volume\volsq_0500.paa)),
	QUOTE(PATHTOF(Data\knobs\volume\volsq_0625.paa)),
	QUOTE(PATHTOF(Data\knobs\volume\volsq_0750.paa)),
	QUOTE(PATHTOF(Data\knobs\volume\volsq_0875.paa)),
	QUOTE(PATHTOF(Data\knobs\volume\vol_1000.paa))
];
private _channelKnobPosition = GET_STATE(channelKnobPosition);
if (_channelKnobPosition == 15) then { //programming mode p
	// Wiggle the knob one state over depending on the selection Dir.
	_newIdx = _volumeKnobPosition + (-1 * GVAR(selectionDir)); // works the opposite way to the sorting.
	if (_newIdx > 16) then { _newIdx = 1; };
	if (_newIdx < 0) then {_newIdx = 15; };
	RADIO_CTRL(107) ctrlSetText (_volImages select _newIdx);
} else {
	RADIO_CTRL(107) ctrlSetText (_volImages select _volumeKnobPosition);
};

// Channel Switch

private _channelImages = [
	QUOTE(PATHTOF(Data\knobs\channel\ch_off.paa)),
	QUOTE(PATHTOF(Data\knobs\channel\ch_on.paa)),
	QUOTE(PATHTOF(Data\knobs\channel\ch_01.paa)),
	QUOTE(PATHTOF(Data\knobs\channel\ch_02.paa)),
	QUOTE(PATHTOF(Data\knobs\channel\ch_03.paa)),
	QUOTE(PATHTOF(Data\knobs\channel\ch_04.paa)),
	QUOTE(PATHTOF(Data\knobs\channel\ch_05.paa)),
	QUOTE(PATHTOF(Data\knobs\channel\ch_06.paa)),
	QUOTE(PATHTOF(Data\knobs\channel\ch_07.paa)),
	QUOTE(PATHTOF(Data\knobs\channel\ch_08.paa)),
	QUOTE(PATHTOF(Data\knobs\channel\ch_09.paa)),
	QUOTE(PATHTOF(Data\knobs\channel\ch_10.paa)),
	QUOTE(PATHTOF(Data\knobs\channel\ch_11.paa)),
	QUOTE(PATHTOF(Data\knobs\channel\ch_12.paa)),
	QUOTE(PATHTOF(Data\knobs\channel\ch_h.paa)),
	QUOTE(PATHTOF(Data\knobs\channel\ch_p.paa))
];

RADIO_CTRL(106) ctrlSetText (_channelImages select _channelKnobPosition);

// PPT Button

if (GVAR(depressedPTT)) then {
	RADIO_CTRL(108) ctrlSetText QUOTE(PATHTOF(Data\knobs\ptt_down.paa));
} else {
	RADIO_CTRL(108) ctrlSetText "";
};

// Audio headset cable

private _audioPath = GET_STATE(audioPath);

if (_audioPath == "HEADSET") then {
	RADIO_CTRL(300) ctrlSetText QUOTE(PATHTOF(Data\ui\sem52slui_headset_ca.paa));
} else {
	RADIO_CTRL(300) ctrlSetText QUOTE(PATHTOF(data\ui\sem52slui_ca.paa));
};

//display
[_display] call FUNC(renderDisplay);

TRACE_3("rendering", _currentChannel, _currentVolume, acre_sys_radio_currentRadioDialog);
true
