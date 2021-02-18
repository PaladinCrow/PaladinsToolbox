//
//  KeychainManager.swift
//  PaladinsToolbox
//
//  Created by John Stanford on 2/17/21.
//

import Foundation

enum KeychainError: Error {
    case itemMissing
}

protocol KeychainManagerProtocol {
    func save(key: String, data: Data) -> OSStatus
    func load(key: String) -> Data?
    func delete(key: String, data: Data) throws -> OSStatus
    func delete(key: String) throws -> OSStatus
    func update(key: String, data: Data)
}

public class KeychainManager: KeychainManagerProtocol {
    private let keychain: KeychainProtocol
    init(_ keychain: KeychainProtocol) {
        self.keychain = keychain
    }
    func save(key: String, data: Data) -> OSStatus {
        let query = createSaveQuery(key: key, data: data)
        return keychain.add(query)
    }
    func load(key: String) -> Data? {
        let query = createSearchQuery(key: key)
        return keychain.search(query)
    }
    func delete(key: String, data: Data) throws -> OSStatus {
        let query = createSaveQuery(key: key, data: data)
        return keychain.delete(query)
    }
    func delete(key: String) throws -> OSStatus {
        if let data = load(key: key) {
            let query = createSaveQuery(key: key, data: data)
            return keychain.delete(query)
        }
        throw KeychainError.itemMissing
    }
    func update(key: String, data: Data) {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword as String,
                                    kSecAttrAccount as String: key]
        let attributes: [String: Any] = [kSecAttrAccount as String: key,
                                         kSecValueData as String: data]
        _ = keychain.update(query, with: attributes)
    }
    private func createSaveQuery(key: String, data: Data) -> [String: Any] {
        let query = [kSecClass as String: kSecClassGenericPassword as String,
                     kSecAttrAccount as String: key,
                     kSecValueData as String: data] as [String: Any]
        return query
    }
    private func createSearchQuery(key: String) -> [String: Any] {
        let query = [kSecClass as String: kSecClassGenericPassword,
                     kSecAttrAccount as String: key,
                     kSecReturnData as String: kCFBooleanTrue!,
                     kSecMatchLimit as String: kSecMatchLimitOne] as [String: Any]
        return query
    }
}

public protocol KeychainProtocol {
    func add (_ query: [String: Any]) -> OSStatus
    func search (_ query: [String: Any]) -> Data?
    func update (_ query: [String: Any], with attributes: [String: Any]) -> OSStatus
    func delete (_ query: [String: Any]) -> OSStatus
}

class Keychain: KeychainProtocol {
    func add(_ query: [String: Any]) -> OSStatus {
        _ = delete(query)
        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil)
    }
    func search(_ query: [String: Any]) -> Data? {
        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status ==  noErr {
            guard let data = dataTypeRef as? Data else {return nil}
            return data
        } else {
            return nil
        }
    }
    func update(_ query: [String: Any], with attributes: [String: Any]) -> OSStatus {
        SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        return 0
    }
    func delete(_ query: [String: Any]) -> OSStatus {
        return SecItemDelete(query as CFDictionary)
    }
}
