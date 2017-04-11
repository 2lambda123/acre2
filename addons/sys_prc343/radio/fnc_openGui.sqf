/*
 * Author: ACRE2Team
 * Opens the GUI of the radio. This is trigered by either double-click in the inventory,
 * through the ACE interact menu (if available) or through the keybinding "open radio".
 *
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Event: "openGui" <STRING> (Unused)
 * 2: Event data <ARRAY> (Unused)
 * 3: Radio data <HASH> (Unused)
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * True <BOOL>
 *
 * Example:
 * ["ACRE_PRC343_ID_1", "openGui", [], [], false] call acre_sys_prc343_fnc_openGui
 *
 * Public: No
 */
#include "script_component.hpp"

TRACE_1("OPENING GUI", _this);
params ["_radioId", "", "", "", ""];

// Prevent radio from being opened if it is externally used
if (_radioId in ACRE_ACTIVE_EXTERNAL_RADIOS) exitWith {
    [ELSTRING(sys_external,noOpenGUI), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
};

disableSerialization;
GVAR(currentRadioId) = _radioId;
createDialog "PRC343_RadioDialog";




true
