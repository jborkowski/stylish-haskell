--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedLists #-}
module Language.Haskell.Stylish.Step.SimpleAlign.Tests
    ( tests
    ) where


--------------------------------------------------------------------------------
import           Test.Framework                            (Test, testGroup)
import           Test.Framework.Providers.HUnit            (testCase)
import           Test.HUnit                                (Assertion)


--------------------------------------------------------------------------------
import           Language.Haskell.Stylish.Step.SimpleAlign
import           Language.Haskell.Stylish.Tests.Util


--------------------------------------------------------------------------------
tests :: Test
tests = testGroup "Language.Haskell.Stylish.Step.SimpleAlign.Tests"
    [ testCase "case 01" case01
    , testCase "case 02" case02
    , testCase "case 03" case03
    , testCase "case 04" case04
    , testCase "case 05" case05
    , testCase "case 06" case06
    , testCase "case 07" case07
    , testCase "case 08" case08
    , testCase "case 09" case09
    , testCase "case 10" case10
    , testCase "case 11" case11
    , testCase "case 12" case12
    ]


--------------------------------------------------------------------------------
case01 :: Assertion
case01 = assertSnippet (step (Just 80) defaultConfig)
    [ "eitherToMaybe e = case e of"
    , "    Left _ -> Nothing"
    , "    Right x -> Just x"
    ]
    [ "eitherToMaybe e = case e of"
    , "    Left _  -> Nothing"
    , "    Right x -> Just x"
    ]


--------------------------------------------------------------------------------
case02 :: Assertion
case02 = assertSnippet (step (Just 80) defaultConfig)
    [ "eitherToMaybe (Left _) = Nothing"
    , "eitherToMaybe (Right x) = Just x"
    ]
    [ "eitherToMaybe (Left _)  = Nothing"
    , "eitherToMaybe (Right x) = Just x"
    ]


--------------------------------------------------------------------------------
case03 :: Assertion
case03 = assertSnippet (step (Just 80) defaultConfig)
    [ "heady def [] = def"
    , "heady _ (x : _) = x"
    ]
    [ "heady def []    = def"
    , "heady _ (x : _) = x"
    ]


--------------------------------------------------------------------------------
case04 :: Assertion
case04 = assertSnippet (step (Just 80) defaultConfig)
    [ "data Foo = Foo"
    , "    { foo :: Int"
    , "    , barqux :: String"
    , "    } deriving (Show)"
    ]
    [ "data Foo = Foo"
    , "    { foo    :: Int"
    , "    , barqux :: String"
    , "    } deriving (Show)"
    ]


--------------------------------------------------------------------------------
case05 :: Assertion
case05 = assertSnippet (step (Just 80) defaultConfig) input input
  where
    -- Don't attempt to align this since a field spans multiple lines
    input =
        [ "data Foo = Foo"
        , "    { foo :: Int"
        , "    , barqux"
        , "         :: String"
        , "    } deriving (Show)"
        ]


--------------------------------------------------------------------------------
case06 :: Assertion
case06 = assertSnippet
    -- 22 max columns is /just/ enough to align this stuff.
    (step (Just 22) defaultConfig)
    [ "data Foo = Foo"
    , "    { foo :: String"
    , "    , barqux :: Int"
    , "    }"
    ]
    [ "data Foo = Foo"
    , "    { foo    :: String"
    , "    , barqux :: Int"
    , "    }"
    ]


--------------------------------------------------------------------------------
case07 :: Assertion
case07 = assertSnippet
    -- 21 max columns is /just NOT/ enough to align this stuff.
    (step (Just 21) defaultConfig)
    [ "data Foo = Foo"
    , "    { foo :: String"
    , "    , barqux :: Int"
    , "    }"
    ]
    [ "data Foo = Foo"
    , "    { foo :: String"
    , "    , barqux :: Int"
    , "    }"
    ]


--------------------------------------------------------------------------------
case08 :: Assertion
case08 = assertSnippet (step (Just 80) defaultConfig)
    [ "canDrink mbAge = case mbAge of"
    , "    Just age | age > 18 -> True"
    , "    _ -> False"
    ]
    [ "canDrink mbAge = case mbAge of"
    , "    Just age | age > 18 -> True"
    , "    _                   -> False"
    ]


--------------------------------------------------------------------------------
case09 :: Assertion
case09 = assertSnippet (step Nothing defaultConfig)
    [ "data Foo = Foo"
    , "    { foo :: String"
    , "    , barqux :: Int"
    , "    }"
    ]
    [ "data Foo = Foo"
    , "    { foo    :: String"
    , "    , barqux :: Int"
    , "    }"
    ]


--------------------------------------------------------------------------------
case10 :: Assertion
case10 = assertSnippet (step Nothing defaultConfig)
    [ "padQual  = case align' of"
    , "  Global -> True"
    , "  File    -> fileAlign"
    , "  Group    -> anyQual"
    ]
    [ "padQual  = case align' of"
    , "  Global -> True"
    , "  File   -> fileAlign"
    , "  Group  -> anyQual"
    ]


--------------------------------------------------------------------------------
case11 :: Assertion
case11 = assertSnippet (step Nothing defaultConfig)
    [ "data Foo = Foo"
    , "    { foo  :: String"
    , "    , barqux  :: !Int"
    , "    }"
    ]
    [ "data Foo = Foo"
    , "    { foo    :: String"
    , "    , barqux :: !Int"
    , "    }"
    ]


--------------------------------------------------------------------------------
case12 :: Assertion
case12 = assertSnippet (step Nothing defaultConfig {cCases = False}) input input
  where
    input =
        [ "case x of"
        , "  Just y -> 1"
        , "  Nothing -> 2"
        ]
