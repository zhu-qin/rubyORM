require_relative ('../lib/associatable')
require_relative ('../lib/db_connection')


class Dog < RubyORM
  self.finalize!

  belongs_to(
   :owner,
   class_name: "Human",
   foreign_key: :owner_id,
   primary_key: :id
  )

  has_one_through(
    :house,
    :owner,
    :house
  )
end


class Human < RubyORM
  self.finalize!

  has_many(
    :dogs,
    class_name: "Dog",
    foreign_key: :owner_id,
    primary_key: :id
  )

  belongs_to(
    :house,
    class_name: "House",
    foreign_key: :house_id,
    primary_key: :id
  )
end

class House < RubyORM
  self.finalize!
  
  has_many(
    :people,
    class_name: "Human",
    foreign_key: :house_id,
    primary_key: :id
  )


end
