require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.constantize
  end

  def table_name
    model_class.table_name
  end
  
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] || "#{name.to_s.singularize}_id".to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || name.to_s.camelcase
  end
end


class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = options[:foreign_key] || "#{self_class_name.to_s.downcase}_id".to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || name.to_s.camelcase.singularize
  end
end

module Associatable

  def assoc_options
    @assoc_options ||= {}
  end

  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name, options)
    define_method(name) do
      options = self.class.assoc_options[name]
      options.class_name.constantize.where(:id => self.attributes[options.foreign_key]).first
    end
  end

  def has_many(name, options = {})
    self.assoc_options[name] = HasManyOptions.new(name, self.to_s, options)
    define_method(name) do
      options = self.class.assoc_options[name]
      options.class_name.constantize.where(options.foreign_key => self.attributes[:id])
    end
  end

  def has_one_through(name, through_name, source_name)

    define_method(name) do
      through_opts = self.class.assoc_options[through_name]
      source_opts = through_opts.model_class.assoc_options[source_name]

      through_table = through_opts.table_name
      through_fk = through_opts.foreign_key
      through_pk = through_opts.primary_key

      source_table = source_opts.table_name
      source_fk = source_opts.foreign_key
      source_pk = source_opts.primary_key

      value = self.send(through_opts.foreign_key)
      results = DBConnection.execute(<<-SQL, value)

      SELECT
        #{source_table}.*
      FROM
        #{through_table}
      JOIN
        #{source_table} ON #{through_table}.#{source_fk} = #{source_table}.#{source_pk}
      WHERE
        #{through_table}.#{through_pk} = ?
      SQL
      res = source_opts.model_class.parse_all(results).first
    end
  end

end

class RubyORM
  extend Associatable
end
