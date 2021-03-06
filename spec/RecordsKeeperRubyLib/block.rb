# Library to work with RecordsKeeper blocks.

#   You can retrieve complete block information by using block class.
#   You just have to pass parameters to invoke the pre-defined functions.

# Import the following libraries

require 'rubygems'
require 'httparty'
require 'json'
require 'binary_parser'
require 'yaml'

module RecordsKeeperRubyLib
	class Block
		# # Entry point for accessing Block class functions
		if File.exist?('config.yaml')
			# Import values from configuration file.
			cfg = YAML::load(File.open('config.yaml','r'))
			
			@url = cfg['url']
			@user = cfg['rkuser']
			@password = cfg['passwd']
			@chain = cfg['chain']
		
		else
			#Import using ENV variables
			
			@url = ENV['url']
    		@user = ENV['rkuser']
    		@password = ENV['passwd']
    		@chain = ENV['chain']	
		end

		# function to retrieve data of a particular block no.
		def self.blockinfo block_height
			height = block_height.to_s
			auth = {:username => @user, :password => @password}
			options = {
				:headers => headers= {"Content-Type"=> "application/json","Cache-Control" => "no-cache"},
				:basic_auth => auth,
				:body => [ {"method":"getblock","params":[height],"jsonrpc":2.0,"id":"curltext","chain_name":@chain}].to_json
			}
			response = HTTParty.get(@url, options)
			out = response.parsed_response
			tx_count_number = out[0]['result']['tx']
			tx_count = tx_count_number.length														# variable returns block's transaction count
			miner = out[0]['result']['miner']														# variable returns block's miner
			size = out[0]['result']['size']															# variable returns block's size
			nonce = out[0]['result']['nonce']														# variable returns block's nonce
			blockHash = out[0]['result']['hash']												# variable returns blockhash
			prevblock = out[0]['result']['previousblockhash']						# variable returns prevblockhash
			nextblock = out[0]['result']['nextblockhash']								# variable returns nextblockhash
			merkleroot = out[0]['result']['merkleroot']									# variable returns merkleroot
			blocktime = out[0]['result']['time']												# variable returns blocktime
			difficulty = out[0]['result']['difficulty']									# variable returns difficulty
			tx = []																											# list to store transaction ids
			for i in 0...tx_count
				tx.push(out[0]['result']['tx'][i])										# pushes transaction ids onto tx list
			end
			retrieved = { :tx_count => tx_count,:miner => miner,:size => size,:nonce => nonce,:blockHash => blockHash,:prevblock => prevblock, :nextblock => nextblock,:merkleroot => merkleroot,:blocktime => blocktime,:difficulty => difficulty,:tx => tx}
			retrievedinfo = JSON.generate retrieved
			return retrievedinfo
		end

		# function to retrieve data of blocks in a particular range
		def self.retrieveBlocks block_range
			blockhash = []
			miner = []
			blocktime = []
			tx_count = []
			auth = {:username => @user, :password => @password}
			options = {
				:headers => headers= {"Content-Type"=> "application/json","Cache-Control" => "no-cache"},
				:basic_auth => auth,
				:body => [ {"method":"listblocks","params":[block_range],"jsonrpc":2.0,"id":"curltext","chain_name":@chain}].to_json
			}
			response = HTTParty.get(@url, options)
			out = response.parsed_response
			block_count_len = out[0]['result']
			block_count = block_count_len.length
			for i in 0...block_count
				blockhash.push(out[0]['result'][i]['hash'])
				miner.push(out[0]['result'][i]['miner'])
				blocktime.push(out[0]['result'][i]['time'])
				tx_count.push(out[0]['result'][i]['txcount'])
			end
			retrieved = { :blockhash => blockhash,:miner => miner,:blocktime => blocktime,:tx_count => tx_count}
			retrievedinfo = JSON.generate retrieved
			return retrievedinfo
		end

	end
end
