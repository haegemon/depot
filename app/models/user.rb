class User < ActiveRecord::Base
    validates :name, presence: true, uniqueness: true
  has_secure_password

    after_destroy

    private
        def ensure_admin_remains
            if User.count.zero?
                raise "One admin must exist"
            end
        end
end
