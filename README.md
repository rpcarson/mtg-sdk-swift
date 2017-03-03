##MTGKit
####Magic: The Gathering SDK - Swift
#####A lightweight framework that makes interacting with the magicthegathering.io api quick, easy and safe. 

##!!all info currently subject to change!!

````swift
let magic = Magic()
````
You can 

````
fetchCards(withParameters:completion:)
fetchSets(withParameters:completion:)
fetchImageForCard(:completion:)
````
Parameters can be constructed as follows:

````swift
let color = CardSearchParameter(parameterType: .colors, value: "black")
let cmc = CardSearchParameter(parameterType: .cmc, value: "2")
let setCode = CardSearchParameter(parameterType: .set, value: "AER")
````
Search parameters come in two flavors: Card and SetSearchParameter. Each one contains an enum holding the valid query names for either cards or sets.

Search parameters are passed to the appropriate fetch method as an array

````swift
magic.fetchCards(withParameters: [color,cmc,set]) {
	cards, error in
	
	if let error = error {
		//handle your error
	}
	
	for c in cards! {
		print(c.name)
	}
	
}
````
The completion contains an optional array of the appropriate type and an optional error type, NetworkError. 

````swift
public enum NetworkError: Error {
    case requestError(Error)
    case unexpectedHTTPResponse(HTTPURLResponse)
    case fetchCardImageError(String)
    case miscError(String)
}
````

fetchImageForCard works similarly, and will retreive a UIImage based on the imageURL of the card you pass it if possible.


####Card Properties
````
public var name: String?
public var names: [String]?
public var manaCost: String?
public var cmc: Int?
public var colors: [String]?
public var colorIdentity: [String]?
public var type: String?
public var supertypes: [String]?
public var types: [String]?
public var subtypes: [String]?
public var rarity: String?
public var set: String?
public var text: String?
public var artist: String?
public var number: String?
public var power: String?
public var toughness: String?
public var layout: String?
public var multiverseid: Int?
public var imageURL: String?
public var rulings: [[String:String]]?
public var foreignNames: [[String:String]]?
public var printings: [String]?
public var originalText: String?
public var originalType: String?
public var id: String?
public var flavor: String?
````

####Set Properties
````
public var code: String?
public var name: String?
public var block: String?
public var type: String?
public var border: String?
public var releaseDate: String?
public var magicCardsInfoCode: String?
public var booster: [[String]]?
````
####Card Search Possible Parameters
````
case name
case cmc
case colors
case type
case supertypes
case subtypes
case rarity
case text
case set
case artist
case power
case toughness
case multiverseid
case gameFormat
````
#### Set Search Possible Parameters
````
case name
case block
````

