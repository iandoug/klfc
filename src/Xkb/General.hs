{-# LANGUAGE UnicodeSyntax, NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Xkb.General where

import BasePrelude
import Prelude.Unicode
import Data.Monoid.Unicode ((∅), (⊕))
import Util (show')
import qualified WithPlus as WP (singleton)

import Control.Monad.Reader (Reader, asks)
import Control.Monad.Writer (tell)
import Lens.Micro.Platform (view, over)

import Layout.Layout (getLetterByPosAndShiftstate, setNullChars)
import Lookup.Linux (modifierAndLevelstring)
import qualified Layout.Modifier as M
import Layout.Types
import PresetLayout (qwerty)

data XkbConfig = XkbConfig
    { __addShortcuts ∷ Bool
    , __redirectAllXkb ∷ Bool
    , __redirectIfExtend ∷ Bool
    }

prepareLayout ∷ Layout → Reader XkbConfig Layout
prepareLayout layout =
    (\addShortcuts →
    over _keys
        ( bool id (over traverse addShortcutLetters) addShortcuts >>>
          setNullChars
        ) layout
    ) <$> asks __addShortcuts

supportedShiftstate ∷ Shiftstate → Logger Bool
supportedShiftstate = fmap and ∘ traverse supportedModifier ∘ toList

supportedModifier ∷ Modifier → Logger Bool
supportedModifier modifier
    | modifier ∈ map fst modifierAndLevelstring = pure True
    | otherwise = False <$ tell ["the modifier " ⊕ show' modifier ⊕ " is not supported in XKB"]

addShortcutLetters ∷ Key → Key
addShortcutLetters key = fromMaybe key $
    over _shiftstates (WP.singleton M.Control :) <$>
    _letters (liftA2 (:) (getLetterByPosAndShiftstate pos (∅) qwerty) ∘ pure) key
  where
    pos = view _pos key