#RubyORM

SQLite3 ORM built with ruby.

####Database Interface
```ruby
#classes should be singularize words of the table names that the class is attempting to model.
class Human < RubyORM
end

#call finalize! to map table columns to an instance variable named attributes for each instance created.
Human.finalize!

#where method will retrieve entries based on the parameters passed in and create an instance of that class.
joe = Human.where(:fname => "Joe")

#attributes method called on an instance returns the keys and values of the entry that maps to table columns
#joe.attributes returns {id:2, fname: "Joe", lname: "Shmoe", house_id: 1}
```

````ruby
Human.all
# all - Class method that returns all objects based on entries in associated table.
# returns all entries from humans table

Human.create(human_attributes)
# create - class method that adds an entry into humans table.
# human_attributes is a hash with key value pairs that match table columns

````
####Associations

````ruby
class Human < RubyORM
  self.finalize!

#has many accepts for its first argument the name of the method that you want the association to be. the second argument is an options hash that has key value pairs that defines the relationship between the tables.
#calling has_many will create a method for the Human class where each instance of human can call the dogs method to retrieve all dogs that have its foreign_key pointing to the human instance.
  has_many(
    :dogs,
    class_name: "Dog",
    foreign_key: :owner_id,
    primary_key: :id
  )

#similarly belongs_to creates a method for a relationship where each instance has it foreign_key point to an entry on the table that has the given class_name
  belongs_to(
    :house,
    class_name: "House",
    foreign_key: :house_id,
    primary_key: :id
  )
end


class Dog < RubyORM
  self.finalize!

  belongs_to(
   :owner,
   class_name: "Human",
   foreign_key: :owner_id,
   primary_key: :id
  )

  # has_one_through - Class method that accepts method_name, through_name, and source_name. Creates an instance method (method_name), that connects two previously defined associations. The through_name is the method defined in the first association and the source_name is the method thats defined on the class in which the through_name was defined.

  has_one_through(
    :house,
    :owner,
    :house
  )
end

````

#future additions

#joins
#has_many_through
