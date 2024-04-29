#include "script_macros.hpp"
/*
 * Author: Pixelated_Grunt
 * Add child actions to ace menu
 *
 * Arguments:
 * Nil
 *
 * Return Value:
 * Nil
 *
 * Example:
 * [] call XDF_fnc_nilocChildActions
 *
 * Public: No
**/


params ["_target"];

private ["_action", "_actions", "_loadIcon", "_saveIcon", "_saveCounts"];

_saveCounts = ["session", ["session.save.counts"]] call FUNCMAIN(getSectionAsHashmap) get "session.save.counts";
_loadIcon = "a3\ui_f\data\igui\cfg\simpletasks\types\upload_ca.paa";
_saveIcon = "a3\ui_f\data\igui\cfg\simpletasks\types\download_ca.paa";
_actions = [];

LOG_1("_saveCounts is (%1).", _saveCounts);
// Load action
_action = [
    "Load",
    "Load Mission",
    _loadIcon,
    { [_this # 1] remoteExec [QFUNCMAIN(loadWorld), 2] },
    {
        params ["", "", "_params"];
        LOG_1("_params is (%1).", _params);
        private _cond = if (_params # 1 > 0) then [{true}, {false}];
        _cond
    },
    {},
    [_loadIcon, _saveCounts],
    nil,
    nil,
    nil,
    {
        params ["", "_player", "_params", "_actionData"];

        _actionData set [2, [_params # 0, _player getVariable [QGVAR(loadStatusColour), HEX_WHITE]]];
    }
] call ace_interact_menu_fnc_createAction;
_actions pushBack [_action, [], _target];

// Save action
_action = [
    "Save",
    "Save Mission",
    _saveIcon,
    { [_this # 1] remoteExec [QFUNCMAIN(saveWorld), 2] },
    { true },
    {},
    _saveIcon,
    nil,
    nil,
    nil,
    {
        params ["", "_player", "_icon", "_actionData"];

        _actionData set [2, [_icon, _player getVariable [QGVAR(saveStatusColour), HEX_WHITE]]];
    }
] call ace_interact_menu_fnc_createAction;
_actions pushBack [_action, [], _target];

_actions
