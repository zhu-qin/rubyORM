RubyORM

SQL lite ORM built with ruby.

SQLObject contains methods:
find - Class method that creates object based on the entry's id
all - Class method that returns all objects based on entries in associated table.
save - Instance method that insert or updates entry based on whether the entry is new or already in DB.
attributes - Instance method that returns a hash with key and values corresponding to table columns

Searchable contains methods:
where - Class method that returns entries corresponding to input params

Associatable contains methods:
has_many - Class method that accepts a name and options hash. The name input corresponds to the instance method created and options hash allows for users override association defaults. Association defaults associates two tables based on table names. i.e has_many (carts) returns instances of carts that belong to the class where the method was defined.

belongs_to - Class method that accepts a name and options hash. The name input corresponds to the instance method created and options hash allows for users override association defaults. Association defaults associates two tables based on table names. i.e belongs_to (house) returns one instance of house that each instance of the class where the method was defined.

has_one_through - Class method that accepts method_name, through_name, and source_name. Creates an instance method (method_name), that connects two previously defined associations. The through_name is the method defined in the first association and the source_name is the method thats defined on the class in which the through_name was defined.
