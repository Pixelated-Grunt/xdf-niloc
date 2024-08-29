#include "script_macros.hpp"
/*
 * Author: Pixelated_Grunt
 * Internal function that provides an interface to get data from the database
 *
 * Arguments:
 * 0: The name of the section to return <STRING>
 * 1: Optional filter of keys that will be returned instead <ARRAY>
 * 2: Optional database instance <OBJECT>
 *
 * Return Value:
 * A hashmap with all key value pairs from the section <HASHMAP>
 *
 * Example:
 * _resHash = ["mission", ["dateTime"]] call XDF_fnc_getSectionAsHashmap
 *
 * Public: No
 */


if (!isServer) exitWith { ERROR("NiLOC only runs on a server.") };
params [
    ["_section", "", [""]],
    ["_filter", [], [[]]],
    ["_db", "", ["", {}]]
];
private ["_keys", "_resHash", "_inidbi"];

_inidbi = if (IS_CODE(_db)) then [{_db}, {[] call FUNCMAIN(getDbInstance)}];
_resHash = createHashMap;
_keys = ["read", ["meta", _section, []]] call _inidbi;

if (count _keys > 0) then {
    if (count _filter > 0) then { _keys = _filter };

    {
        private "_value";

        _value = ["read", [_section, _x]] call _inidbi;
        if (_value isNotEqualTo false) then { _resHash set [_x, _value] };
    } forEach _keys;
} else {
    WARNING_1("Trying to read from section (%1) that does not exist.", _section);
};

_resHash