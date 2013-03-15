class User < ActiveRecord::Base

  # ...

  include AutoAudit
  audit columns: ['first_name','last_name']

  # ...

end
