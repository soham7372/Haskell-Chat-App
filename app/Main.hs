-- Main.hs
{-|
Module      : Main
Description : This is the main module where the chat application starts.
-}

{-# LANGUAGE BangPatterns #-}

import Control.Concurrent
import Control.Monad
import System.IO
import User
import Message
import Activity

main :: IO ()
main = do
  globalCounter <- newMVar 0

  -- | Creates a file and saves the chat history
  withFile "chats.txt" AppendMode $ \logHandle -> do
    let usernames = ["Iron Man", "Thor", "Ant-Man", "Hulk", "Captain America", "Hawkeye", "Black Widow", "Doctor Strange", "Spider-Man", "DeadPool"]
    users <- mapM createUser usernames
    mapM_ (forkIO . userActivity globalCounter logHandle users) users
    threadDelay 10000000
    
    putStrLn $ "\n\n---- Message Count ----"
    totalMessages <- newMVar 0
    forM_ users $ \user -> do
        messages <- readMVar (receivedMessages user)
        putStrLn $ username user ++ " received " ++ show (length messages) ++ " messages."
        modifyMVar_ totalMessages (\total -> return (total + length messages))
    total <- readMVar totalMessages
    putStrLn $ "\n---------------------------\nTotal messages received: " ++ show total ++ "\n\n"