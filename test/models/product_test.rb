require 'test_helper'

class ProductTest < ActiveSupport::TestCase
    fixtures :products
  # test "the truth" do
  #   assert true
  # end

    def new_product(image_url = 'fred.gif', title = "My title")
        Product.new(title: title,
                    :description => 'test desxcr',
                    image_url: image_url,
                    price: 1
        )
    end

    test "product attributes must not be empty" do
        product = Product.new
        assert product.invalid?
        assert product.errors[:title].any?
        assert product.errors[:description].any?
        assert product.errors[:price].any?
        assert product.errors[:image_url].any?
    end

    test "price must be positive" do
        product = Product.new(title: "My title",
                            :description => 'test desxcr',
                            image_url: 'zzz.jpg',
        )
        product.price = -1
        assert product.invalid?
        assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

        product.price = 0
        assert product.invalid?
        assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

        product.price = 1
        assert product.valid?
    end

    test "image url" do
        ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.x/y/z/fred.gif}
        bad = %w{ fred.doc fred.gif/more fred.gif.more}

        ok.each do |name|
            assert new_product(name).valid?, "#{name} shouldn't be invalid"
        end

        bad.each do |name|
            assert new_product(name).invalid?, "#{name} shouldn't be valid"
        end
    end

    test "product is not valid without unique title" do
        product = new_product('fred.gif', products(:one).title)
        assert product.invalid?
        assert_equal [I18n.translate("activerecord.errors.messages.taken")], product.errors[:title]
    end

end
