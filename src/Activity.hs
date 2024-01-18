-- Activity.hs
{-|
Module      : Activity
Description : This module defines the functions related to user activities.
-}

{-# LANGUAGE BangPatterns #-}

module Activity (
  -- * Functions
  userActivity,
  sendMessage
) where

import Control.Concurrent
import Control.Monad
import System.Random
import System.IO
import User
import Message

-- | The 'predefinedTexts' is a list of predefined texts that can be used as message content.
predefinedTexts :: [String]
predefinedTexts = ["Hello", "How are you?", "Good day!", "See you later", "What's up?"]

-- | The 'sendMessage' function sends a message from one user to another.
sendMessage :: MVar Int -> Handle -> User -> User -> Message -> IO ()
sendMessage !globalCounter !logHandle !fromUser !toUser !message = do
  modifyMVar_ globalCounter $ \count -> 
    if count < 100 
    then do
      modifyMVar_ (receivedMessages toUser) (\messages -> return $ message : messages)
      let messageDetails = "\nFrom: " ++ username fromUser ++ "\nTo: " ++ username toUser ++ "\nMessage: " ++ show message
      hPutStrLn logHandle messageDetails
      putStrLn messageDetails  -- Print the message details to the terminal
      return $ count + 1
    else return count

-- | The 'userActivity' function simulates the activity of a user.
userActivity :: MVar Int -> Handle -> [User] -> User -> IO ()
userActivity !globalCounter !logHandle !users !currentUser = replicateM_ 100 $ do
  threadDelay =<< randomRIO (100000, 500000)

  let sender = username currentUser
  let possibleRecipients = filter (\user -> username user /= sender) users

  recipientIndex <- randomRIO (0, length possibleRecipients - 1)
  let recipient = possibleRecipients !! recipientIndex

  textIndex <- randomRIO (0, length predefinedTexts - 1)
  let messageContent = predefinedTexts !! textIndex
  let message = Message sender messageContent
  
  sendMessage globalCounter logHandle currentUser recipient message


  

  