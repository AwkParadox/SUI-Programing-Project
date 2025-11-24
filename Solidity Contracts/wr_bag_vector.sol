// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WrBag {
    // Struct definitions
    struct Hero {
        uint256 id;
        mapping(uint256 => Accessory) bag;
        uint64[] accessoriesVector;
        bool exists;
    }
    
    struct Sword {
        uint256 id;
        uint64 strength;
    }
    
    struct Shield {
        uint256 id;
        uint64 strength;
    }
    
    struct Hat {
        uint256 id;
        uint64 strength;
    }
    
    // Union type for accessories stored in bag
    enum AccessoryType { None, Sword, Shield, Hat }
    
    struct Accessory {
        AccessoryType accessoryType;
        uint256 id;
        uint64 strength;
    }
    
    // Storage mappings
    mapping(uint256 => Hero) public heroes;
    mapping(uint256 => bool) public heroExists;
    uint256 private nextHeroId;
    
    // Creates 10 heroes, each with a bag containing 3 accessories
    function createHeroesWithWrappedBag() external {
        for (uint256 i = 0; i < 10; i++) {
            uint256 heroId = nextHeroId++;
            
            // Create accessories vector with 200 elements
            uint64[] memory accessoriesVector = new uint64[](200);
            for (uint256 j = 0; j < 200; j++) {
                accessoriesVector[j] = uint64(j);
            }
            
            // Create hero with bag
            Hero storage hero = heroes[heroId];
            hero.id = heroId;
            hero.accessoriesVector = accessoriesVector;
            hero.exists = true;
            heroExists[heroId] = true;
            
            // Create and add accessories to bag
            // Sword at index 0
            hero.bag[0] = Accessory({
                accessoryType: AccessoryType.Sword,
                id: i,
                strength: 0
            });
            
            // Shield at index 1
            hero.bag[1] = Accessory({
                accessoryType: AccessoryType.Shield,
                id: i,
                strength: 0
            });
            
            // Hat at index 2
            hero.bag[2] = Accessory({
                accessoryType: AccessoryType.Hat,
                id: i,
                strength: 0
            });
            
        }
    }
    
    // Access hero with bag wrapped (1000 iterations)
    function accessHeroWithBagWrapped(uint256 heroId) view external {
        require(heroExists[heroId], "Hero does not exist");
        Hero storage hero = heroes[heroId];
        
        // Run 0th iteration
        Accessory storage sword = hero.bag[0];
        Accessory storage shield = hero.bag[1];
        Accessory storage hat = hero.bag[2];
        
        // Prevent unused variable warnings
        sword; shield; hat;
        
        // Repeatedly run access operations (999 more iterations)
        for (uint256 i = 1; i < 1000; i++) {
            sword = hero.bag[0];
            shield = hero.bag[1];
            hat = hero.bag[2];
        }
    }
    
    // Update hero with bag wrapped (1000 iterations)
    function updateHeroWithBagWrapped(uint256 heroId) external {
        require(heroExists[heroId], "Hero does not exist");
        Hero storage hero = heroes[heroId];
        
        // Run 0th iteration
        hero.bag[0].strength += 10;
        hero.bag[1].strength += 10;
        hero.bag[2].strength += 10;
        
        // Repeatedly run update operations (999 more iterations)
        for (uint256 i = 1; i < 1000; i++) {
            hero.bag[0].strength += 10;
            hero.bag[1].strength += 10;
            hero.bag[2].strength += 10;
        }
    }
    
    // Delete hero with bag wrapped
    function deleteHeroWithBagWrapped(uint256 heroId) external {
        require(heroExists[heroId], "Hero does not exist");
        
        // Delete bag contents
        deleteBagContents(heroId);
        
        // Delete hero
        delete heroes[heroId];
        delete heroExists[heroId];
    }
    
    // Delete bag contents
    function deleteBagContents(uint256 heroId) private {
        deleteSwordFromBag(heroId);
        deleteShieldFromBag(heroId);
        deleteHatFromBag(heroId);
    }
    
    // Delete sword from bag
    function deleteSwordFromBag(uint256 heroId) private {
        Hero storage hero = heroes[heroId];
        delete hero.bag[0];
    }
    
    // Delete shield from bag
    function deleteShieldFromBag(uint256 heroId) private {
        Hero storage hero = heroes[heroId];
        delete hero.bag[1];
    }
    
    // Delete hat from bag
    function deleteHatFromBag(uint256 heroId) private {
        Hero storage hero = heroes[heroId];
        delete hero.bag[2];
    }
    
    // View functions to read hero data
    function getHero(uint256 heroId) external view returns (
        uint256 id,
        uint64[] memory accessoriesVector,
        bool exists
    ) {
        require(heroExists[heroId], "Hero does not exist");
        Hero storage hero = heroes[heroId];
        return (hero.id, hero.accessoriesVector, hero.exists);
    }
    
    function getAccessory(uint256 heroId, uint256 index) external view returns (
        AccessoryType accessoryType,
        uint256 id,
        uint64 strength
    ) {
        require(heroExists[heroId], "Hero does not exist");
        Accessory storage accessory = heroes[heroId].bag[index];
        return (accessory.accessoryType, accessory.id, accessory.strength);
    }
}