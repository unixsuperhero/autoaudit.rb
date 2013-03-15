module AutoAudit

  def self.included(base)
    base.cattr_accessor :audit_columns, :audit_table, :audit_polymorphic
    base.extend DSL
  end

  def apply_audit
    changes.map{|col,vals|
      if audit_columns.include?(col)
        send(audit_table).create(col_name: col, before: vals.first, after: vals.last)
      end
    }
  end

  module DSL
    attr_accessor :audit_columns, :audit_table, :audit_polymorphic
    def audit(opts)
      options = {
          polymorphic: false,
          table: [table_name.singularize, 'changes'].join('_'),
          columns: []
        }.merge(opts)

      self.audit_columns = options[:columns].map(&:to_s)
      self.audit_table = options[:table]
      self.audit_polymorphic = options[:polymorphic]

      before_update :apply_audit
      has_many options[:table].to_sym
    end

    def audit_all(opts)
      options = {
          polymorphic: false,
          table: [table_name, 'changes'].join('_'),
          columns: []
        }.merge(opts)

      self.audit_columns = column_names
      self.audit_table = options[:table]
      self.audit_polymorphic = options[:polymorphic]

      before_update :apply_audit
      has_many options[:table].to_sym
    end
  end
end
