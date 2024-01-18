-- Message.hs
{-|
Module      : Message
Description : This module defines the Message data type.
-}

{-# LANGUAGE BangPatterns #-}

module Message (
-- * Data Types
  Message(Message,fromUser, content)
) where

-- | The 'Message' data type represents a message in the chat application.
data Message = Message {
  fromUser :: String,   -- ^ The 'fromUser' field represents the sender of the 
  content :: String     -- ^ The 'content' field represents the content of the message.
}

-- | The 'Show' instance enables us to convert 'Message' to 'String'.
instance Show Message where
  show (Message from content) = content