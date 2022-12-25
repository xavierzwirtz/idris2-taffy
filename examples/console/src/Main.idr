module Main

import TaffyBindings
import TaffyExtBindings
import Data.String

defaultTaffyStyleDimension : TaffyBindings.TaffyStyleDimension
defaultTaffyStyleDimension = MkTaffyStyleDimension 2 0

taffyLengthPercentageZero : TaffyBindings.TaffyStyleDimension
taffyLengthPercentageZero = MkTaffyStyleDimension 0 0

defaultTaffyStyleRect : TaffyStyleRect
defaultTaffyStyleRect = MkTaffyStyleRect
  defaultTaffyStyleDimension
  defaultTaffyStyleDimension
  defaultTaffyStyleDimension
  defaultTaffyStyleDimension

defaultTaffyStyleRect_Zero : TaffyStyleRect
defaultTaffyStyleRect_Zero = MkTaffyStyleRect
  taffyLengthPercentageZero
  taffyLengthPercentageZero
  taffyLengthPercentageZero
  taffyLengthPercentageZero

defaultTaffyStyleSize : TaffyStyleSize
defaultTaffyStyleSize = MkTaffyStyleSize
  defaultTaffyStyleDimension
  defaultTaffyStyleDimension

defaultTaffyStyleSize_Zero : TaffyStyleSize
defaultTaffyStyleSize_Zero = MkTaffyStyleSize
  taffyLengthPercentageZero
  taffyLengthPercentageZero

printLayoutTree
  : Idris2_Taffy_Ext_Layout
  -> Nat
  -> IO ()
printLayoutTree layout level =
  let
    x = get_Idris2_Taffy_Ext_Layout_x layout
    y = get_Idris2_Taffy_Ext_Layout_y layout
    width = get_Idris2_Taffy_Ext_Layout_width layout
    height = get_Idris2_Taffy_Ext_Layout_height layout
    childCount = get_Idris2_Taffy_Ext_Layout_childCount layout
    prefix' = replicate (level * 2) ' '
  in do
  putStrLn "\{prefix'}x: \{show x}, y: \{show y}, width: \{show width}, height: \{show height}, childCount: \{show childCount}"
  if childCount == 0
    then pure ()
    else
      traverse_
        (\i => do
          child <- idris2_Taffy_Ext_Layout_get_child layout (i - 1)
          printLayoutTree child (level + 1))
        [1..childCount]

main : IO ()
main = do
  taffy <- taffy_init

  child_style <- taffy_style_create
    0 -- display
    0 -- position_type
    0 -- flex_direction
    0 -- flex_wrap
    0 -- align_items
    0 -- align_self
    0 -- align_content
    0 -- justify_content
    defaultTaffyStyleRect -- position
    defaultTaffyStyleRect -- margin
    defaultTaffyStyleRect_Zero -- padding
    defaultTaffyStyleRect_Zero -- border
    defaultTaffyStyleSize_Zero -- gap
    0 -- flex_grow
    0 -- flex_shrink
    defaultTaffyStyleDimension -- flex_basis
    (MkTaffyStyleSize
      (MkTaffyStyleDimension 1 0.5)
      (MkTaffyStyleDimension 2 0.0)) -- style
    defaultTaffyStyleSize -- min_size
    defaultTaffyStyleSize -- max_size,
   (MkTaffyStyleDimension 0 0) -- aspect_ratio

  child <- taffy_node_create taffy child_style

  node_style <- taffy_style_create
    0 -- display
    0 -- position_type
    0 -- flex_direction
    0 -- flex_wrap
    0 -- align_items
    0 -- align_self
    0 -- align_content
    2 -- justify_content
    defaultTaffyStyleRect -- position
    defaultTaffyStyleRect -- margin
    defaultTaffyStyleRect_Zero -- padding
    defaultTaffyStyleRect_Zero -- border
    defaultTaffyStyleSize_Zero -- gap
    0 -- flex_grow
    0 -- flex_shrink
    defaultTaffyStyleDimension -- flex_basis
    (MkTaffyStyleSize
      (MkTaffyStyleDimension 0 100)
      (MkTaffyStyleDimension 0 100)) -- style
    defaultTaffyStyleSize -- min_size
    defaultTaffyStyleSize -- max_size,
    (MkTaffyStyleDimension 0 0) -- aspect_ratio

  node <- taffy_node_create taffy node_style

  taffy_node_add_child taffy node child

  layout <- idris2_taffy_ext_compute_layout taffy node (MkTaffyStyleDimension 0 0) (MkTaffyStyleDimension 0 0)
  printLayoutTree layout 0
