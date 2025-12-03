module wr_bag::F_hero_with_bag_wrapped{
    use sui::bag;

    public struct Hero has key, store{
        id: UID,
        bag: bag::Bag
    }

    public struct Sword has key, store{
        id: UID,
        strength: u64
    }
    
    public struct Shield has key, store{
        id: UID,
        strength: u64
    }

    public struct Hat has key, store{
        id: UID,
        strength: u64
    }

    // Creates a many objects that each have a bag as a wrapped element (10)
    // Also attaches 3 accessories to bag within
    public entry fun create_heroes_with_wrapped_bag(ctx: &mut TxContext){
        let mut i: u64 = 0;
        while(i < 10){
            let bag_object = bag::new(ctx);

            //1) Create hero (bag included as field)
            let mut hero = Hero{
                id: object::new(ctx),
                bag: bag_object
            };

            //2) Create accessories and attach to bag
            // creating hero attributes
            let mut sword = Sword{id: object::new(ctx), strength: 0};
            let mut shield = Shield{id: object::new(ctx), strength: 0};
            let mut hat = Hat{id: object::new(ctx), strength: 0};
            
            // adding hero attributes to bag
            bag::add(&mut hero.bag, 0, sword);
            bag::add(&mut hero.bag, 1, shield);
            bag::add(&mut hero.bag, 2, hat);

            //3) Transfer object to user
            transfer::transfer(hero, tx_context::sender(ctx));
            
            i = i + 1;
        }
    }

    public entry fun access_hero_with_bag_wrapped(hero_obj_ref: &mut Hero){
        //1) Run 0th iteration
        let mut i = 0;
        //A) Get mutable reference to bag
        let mut bag_ref: &mut bag::Bag = &mut hero_obj_ref.bag;
        //B) Get mut ref to bag elements
        let mut sword: &mut Sword = bag::borrow_mut(bag_ref, 0);
        let mut shield: &mut Shield = bag::borrow_mut(bag_ref, 1);
        let mut hat: &mut Hat = bag::borrow_mut(bag_ref, 2);
        //C) Update loop counter
        i = i + 1;
        //2) Repeatedly run access operations
        while(i < 1000){
            //A) Get mutable reference to bag
            bag_ref = &mut hero_obj_ref.bag;
            //B) Get mut ref to bag elements
            sword = bag::borrow_mut(bag_ref, 0);
            shield = bag::borrow_mut(bag_ref, 1);
            hat = bag::borrow_mut(bag_ref, 2);
            //C) Update loop counter
            i = i + 1;
        }
    }
    
    public entry fun update_hero_with_bag_wrapped(hero_obj_ref: &mut Hero){
        //1) Run 0th iteration
        let mut i = 0;
        //A) Get mutable reference to bag
        let mut bag_ref: &mut bag::Bag = &mut hero_obj_ref.bag;
        //B) Get mut ref to & update bag elements
        let mut sword: &mut Sword = bag::borrow_mut(bag_ref, 0);
        sword.strength = sword.strength + 10;

        let mut shield: &mut Shield = bag::borrow_mut(bag_ref, 1);
        shield.strength = shield.strength + 10;

        let mut hat: &mut Hat = bag::borrow_mut(bag_ref, 2);
        hat.strength = hat.strength + 10;

        //C) Update loop counter
        i = i + 1;

        //2) Repeatedly run update operations
        while(i < 1000){
            //A) Get mutable reference to bag
            bag_ref = &mut hero_obj_ref.bag;
            //B) Get mut ref to & update bag elements
            sword = bag::borrow_mut(bag_ref, 0);
            sword.strength = sword.strength + 10;

            shield = bag::borrow_mut(bag_ref, 1);
            shield.strength = shield.strength + 10;
            
            hat = bag::borrow_mut(bag_ref, 2);
            hat.strength = hat.strength + 10;
            //C) Update loop counter
            i = i + 1;
        }
    }

    public entry fun delete_hero_with_bag_wrapped(mut hero: Hero){
        //1) Delete_bag_contents
        delete_bag_contents(&mut hero);
        
        //2) Unpack and delete Hero
        let Hero{id, bag} = hero;
        object::delete(id);

        //3) Delete Bag
        bag::destroy_empty(bag);
    }

    public fun delete_bag_contents(hero_obj_ref: &mut Hero){
        //1) Set up mut_ref to bag using borrow_mut
        let mut bag_ref: &mut bag::Bag = &mut hero_obj_ref.bag;
        //2) Call delete on accessories within bag
        delete_sword_from_bag(bag_ref);
        delete_shield_from_bag(bag_ref);
        delete_hat_from_bag(bag_ref);
    }
    
    public fun delete_sword_from_bag(bag_ref: &mut bag::Bag){
        //1) Unpack Sword
        let Sword {id, strength:_} = bag::remove(bag_ref, 0);
        //2) Delete ID
        object::delete(id);
    }

    public fun delete_shield_from_bag(bag_ref: &mut bag::Bag){
        //1) Unpack Sword
        let Shield {id, strength:_} = bag::remove(bag_ref, 1);
        //2) Delete ID
        object::delete(id);
    }

    public fun delete_hat_from_bag(bag_ref: &mut bag::Bag){
        //1) Unpack Sword
        let Hat {id, strength:_} = bag::remove(bag_ref, 2);
        //2) Delete ID
        object::delete(id);
    }
}
