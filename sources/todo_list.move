module todo_list::todo_list {
   use std::string::String;

   public struct TodoList has key, store {
      id: UID,
      items: vector<String>
   }

   /// Create a new todo list and transfer
   fun init(ctx: &mut TxContext) {
      transfer::transfer(TodoList {
         id: object::new(ctx),
         items: vector[]
      }, ctx.sender());
   }

   /// Create a new todo list.
   public fun new(ctx: &mut TxContext): TodoList {
      let list = TodoList {
      id: object::new(ctx),
      items: vector[]
      };

       (list)
   }

   /// Add a new todo item to the list.
   entry fun add(list: &mut TodoList, item: String) {
      list.items.push_back(item);
   }

   /// Remove a todo item from the list by index.
   entry fun remove(list: &mut TodoList, index: u64): String {
      list.items.remove(index)
   }

   /// Delete the list and the capability to manage it.
   entry fun delete(list: TodoList) {
      let TodoList { id, items: _ } = list;
      id.delete();
   }

   /// Get the number of items in the list.
   entry fun length(list: &TodoList): u64 {
      list.items.length()
   }

}
