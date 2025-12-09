# SM-DYS-Pub-Spawn-Reduction
Reduces spawn time for pubs when there are over 10 players, only designed to work for up to 32 players

# How it works  
The formula for reducing the spawn period: `spawnTime - ((spawnTime * 0.5) * (players / 32.0))`. This scales the spawn time linearly from the normal spawn amount for class, capped up to half that value as players approach the max of 32, so at the 32 player cap, every player will have half their normal spawn time added to the queue.
**experimental, only works for linux**
