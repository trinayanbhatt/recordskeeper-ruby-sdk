require 'test/unit'
require_relative ('ruby2/address.rb')

module Ruby2
  class AddressTest < Test::Unit::TestCase
    @@cfg = YAML::load(File.open('config.yaml','r'))
    @@net = Address.variable
    def test_getaddress
      address = Address.getAddress
      address_size = address.length
      assert_equal address_size, 34
    end
    def test_getmultisigaddress
      address = Address.getMultisigAddress 2,  @@net['samplegetmultisigaddress']
      assert_equal address, @@net['multisigaddress']
    end

    def test_checkifvalid
      checkaddress = Address.checkifValid @@net['validaddress']
      assert_equal checkaddress, 'Address is valid'
    end

    def test_failcheckifvalid
      wrongaddress = Address.checkifValid @@net['invalidaddress']
      assert_equal wrongaddress, 'Address is valid'
    end

    def test_checkifmineallowed
      checkaddress = Address.checkifMineAllowed @@net['miningaddress']
      assert_equal checkaddress, 'Address has mining permission'
    end

    def test_failcheckifmineallowed
      wrongaddress = Address.checkifMineAllowed @@net['nonminingaddress']
      assert_equal wrongaddress, 'Address mining permission'
    end
    def test_checkbalance
      balance = Address.checkBalance @@net['nonminingaddress']
      assert_equal balance, 5
    end
    def test_getmultisigwalletaddress
      address = Address.getMultisigWalletAddress 2, @@net['samplegetmultisigaddress']
      assert_equal address, @@net['multisigaddress']
    end
    def test_importaddress
      address = Address.importAddress @@net['miningaddress']
      assert_equal address, "Address successfully imported"
    end
    def test_wrongimportaddress
      address = Address.importAddress @@net['wrongimportaddress']
      assert_equal address, "Invalid Rk address or script"
    end

  end
end