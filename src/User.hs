-- User.hs
{-|
Module      : User
Description : This module defines the User data type and its related functions.
-}

{-# LANGUAGE BangPatterns #-}

module User (
    -- * Data Types
  User(username, receivedMessages)
    -- * Function
  , createUser
) where

import Control.Concurrent
import Message

 -- | The 'User' data type represents a user in the chat application.
data User = User {
  username :: String,   -- ^ The 'username' of the user.
  receivedMessages :: MVar [Message]    -- ^ The 'receivedMessages' is a list of messages received by the user.
}

-- | The 'createUser' function creates a new user.
createUser :: String -> IO User
createUser name = do
  mbox <- newMVar []
  return $ User name mbox