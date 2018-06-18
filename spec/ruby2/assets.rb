#   Library to work with assets.

#   You can issue assets or retrieve assets information by using asset class.
#   You just have to pass parameters to invoke the pre-defined functions.

require 'rubygems'
require 'httparty'
require 'json'
require 'binary_parser'
require 'yaml'
require 'hex_string'

module Ruby2
	class Assets
		# # Entry point for accessing Block class resources.
		# # Import values from config file.
		cfg = YAML::load(File.open('config.yaml','r'))
		@network = cfg['testnet']								# Network variable to store the networrk that you want to access
		if @network==cfg['testnet']
			@url = cfg['testnet']['url']
			@user = cfg['testnet']['rkuser']
			@password = cfg['testnet']['passwd']
			@chain = cfg['testnet']['chain']
		else
			@url = cfg['mainnet']['url']
			@user = cfg['mainnet']['rkuser']
			@password = cfg['mainnet']['passwd']
			@chain = cfg['mainnet']['chain']
		end

		def self.variable
			net = @network
			return net
		end


	  # Function to create or issue an asset
	  def self.createAsset address, asset_name, asset_qty
	    auth = {:username => @user, :password => @password}
	    options = {
	      :headers => headers= {"Content-Type"=> "application/json","Cache-Control" => "no-cache"},
	      :basic_auth => auth,
	      :body => [ {"method":"issue","params":[address, asset_name, asset_qty],"jsonrpc":2.0,"id":"curltext","chain_name":@chain}].to_json
	    }
	    response = HTTParty.get(@url, options)
	    out = response.parsed_response
	    txid = out[0]['result']
	    return txid;										# Variable to store issue transaction id
	  end

	  # Function to retrieve assets information
	  def self.retrieveAssets
	    asset_name = []
	    issue_id = []
	    issue_qty = []
	    auth = {:username => @user, :password => @password}
	    options = {
	      :headers => headers= {"Content-Type"=> "application/json","Cache-Control" => "no-cache"},
	      :basic_auth => auth,
	      :body => [ {"method":"listassets","params":[],"jsonrpc":2.0,"id":"curltext","chain_name":@chain}].to_json
	    }
	    response = HTTParty.get(@url, options)
	    out = response.parsed_response
	    asset_count = out[0]['result'].length											# Returns assets count
	    for i in 0...asset_count
	      asset_name.push(out[0]['result'][i]['name'])		  			# Returns asset name
	      issue_id.push(out[0]['result'][i]['issuetxid'])	  			# Returns issue id
	      issue_qty.push(out[0]['result'][i]['issueraw'])					# Returns issue quantity
	    end
	    return asset_name, issue_id, issue_qty, asset_count;
	  end

		# Function to send quantity of assets to an address
		def self.sendasset address, asset_name, asset_qty
			auth = {:username => @user, :password => @password}
	    options = {
	      :headers => headers= {"Content-Type"=> "application/json","Cache-Control" => "no-cache"},
	      :basic_auth => auth,
	      :body => [ {"method":"sendasset","params":[address, asset_name, asset_qty],"jsonrpc":2.0,"id":"curltext","chain_name":@chain}].to_json
	    }
	    response = HTTParty.get(@url, options)
	    out = response.parsed_response
			txid = out[0]['result']
			return txid;										# Variable to store send asset transaction id
		end
	end
end
