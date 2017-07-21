//
//  Decoding.swift
//  XcodeGen
//
//  Created by Yonas Kolb on 19/5/17.
//
//

import Foundation
import JSONUtilities

extension Dictionary where Key: JSONKey {

    public func json<T: NamedJSONDictionaryConvertible>(atKeyPath keyPath: KeyPath, invalidItemBehaviour: InvalidItemBehaviour<T> = .remove) throws -> [T] {
        guard let dictionary = json(atKeyPath: keyPath) as JSONDictionary? else {
            return []
        }
        var items: [T] = []
        for (key, _) in dictionary {
            let jsonDictionary: JSONDictionary = try dictionary.json(atKeyPath: .key(key))
            let item = try T(name: key, jsonDictionary: jsonDictionary)
            items.append(item)
        }
        return items
    }

    public func json<T: NamedJSONConvertible>(atKeyPath keyPath: KeyPath, invalidItemBehaviour: InvalidItemBehaviour<T> = .remove) throws -> [T] {
        guard let dictionary = json(atKeyPath: keyPath) as JSONDictionary? else {
            return []
        }
        var items: [T] = []
        for (key, value) in dictionary {
            let item = try T(name: key, json: value)
            items.append(item)
        }
        return items
    }
}

public protocol NamedJSONDictionaryConvertible {

    init(name: String, jsonDictionary: JSONDictionary) throws
}

public protocol NamedJSONConvertible {

    init(name: String, json: Any) throws
}
