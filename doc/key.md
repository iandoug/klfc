Key
===

A key denotes the actions caused by the press of a key on the keyboard. A key has the following attributes:

* Position (`pos`).
* Shortcut position (`shortcutPos`).
* Letters (`letters`).
* Shiftstates (`shiftstates`).
* Caps Lock (`capslock`).
* Filter (`filter`).

If multiple files contain keys with the same positions, the separate keys will be merged. The letters will be combined and the last explicit definition of a shortcut position, the influence of Caps Lock or a letter is used. For example, if file 1 contains the key:

    {
        "pos": "S",
        "shortcutPos": "R",
        "letters": [ "r", "R" ],
        "shiftstates": [ "None", "Shift" ],
        "capslock": false
    }

and file 2 the key:

    {
        "pos": "S",
        "shortcutPos": "S",
        "letters": [ "s", "S", "ß" ],
        "shiftstates": [ "None", "Shift", "AltGr" ]
    }

the resulting key is:

    {
        "pos": "S",
        "shortcutPos": "S",
        "letters": [ "s", "S", "ß" ],
        "shiftstates": [ "None", "Shift", "AltGr" ],
        "capslock": false
    }

The same applies if the keys are defined in the same file, which will only be useful when the `filter` attribute is used on at least one of the keys.

Position
--------

The `pos` attribute corresponds to the position of the key on a QWERTY keyboard.
For a full list of available positions, see [lists/positions.md](lists/positions.md).

Shortcut position
-----------------

The `shortcutPos` attribute corresponds to the position used in shortcuts. If `qwertyShortcuts` is `true`, it will be set to the QWERTY location.

By default, the shortcut position will be the (QWERTY) position of the first character. If the first character has no corresponding position, the shortcut position will be the same as the normal position.

Letters
-------

The `letters` attribute corresponds to a list of letters. The letter in the nth position is activated when the nth shiftstate in the corresponding `shiftstates` attribute is active.

A letter can be one of the following:

* A single Unicode character, e.g. `a`.
* Multiple Unicode characters (a 'ligature'), e.g. `ĳ:ij` (that is, the single Unicode character `ĳ`, `U+0133` LATIN SMALL LIGATURE IJ, followed by a `:`, `i` and `j`). In XKB, a single base character is needed and can be provided before a colon. If no base character is applicable, the prefix `ligature:` or `lig:` can be used and a Unicode character from the private use area is used.
* An action, e.g. `Backspace`. For a full list of available actions, see [lists/actions.md](lists/actions.md).
* A predefined dead key, e.g. `acute`. The prefixes `deadKey:`, `dead:` and `dk:` can be used, but aren't necessary. For a full list of available predefined dead keys, see [lists/deadkeys.md](lists/deadkeys.md).
* A custom dead key, e.g. `customDeadKey:math`. The definition of the custom dead key has to be included in the same file. The prefix `customDeadKey:`, `customDead:` or `cdk:` is necessary.
* A redirected key, e.g. `Control+Shift+T`. This is a list of modifiers with at the end the position to redirect to, all separated by a `+`, optionally prefixed with `redirect:` or `red:`. If a redirected key has no modifiers, it can have the same name as an action. In that case, it is necessary to prepend the letter with `redirect:` or `red:`. Depending on the output format, the position will be adjusted to the keyboard layout. So, `Control+C` should always copy text and `red:C` should always output 'c', independent from the position of the letter 'c' on the keyboard layout.
* The empty action, denoted by the empty string. Useful for filling up unused modifiers, but often it is better to use multiple files to separate different layout layers.

Shiftstates
-----------

The same as the global `shiftstates` attribute, but the local one will overwrite the global one. Useful when the shiftstates of only a single key differ from the other.

Caps Lock
---------

The `capslock` attribute corresponds to the influence of the Caps Lock state. If `capslock` is `true` and Caps Lock is active, the pressed letter will be capitalized. If `capslock` is `false`, the Caps Lock state will be ignored.

By default, Caps Lock will be set iff the first letter is an alphabetic character.

Filter
------

The same as the global `filter` attribute, but the local one only filters the key it corresponds to.