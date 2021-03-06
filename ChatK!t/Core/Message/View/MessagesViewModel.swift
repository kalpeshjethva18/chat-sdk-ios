//
//  ChatViewModel.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation

@objc public class MessagesViewModel: NSObject, UITableViewDataSource {
    
    let _thread: Thread
    let _messageTimeFormatter = DateFormatter()
    
    var _messages = [Message]()
    
    var _messageCellRegistrations = [String: MessageCellRegistration]()
    
    @objc public init(thread: Thread) {
        _thread = thread
        _messageTimeFormatter.setLocalizedDateFormatFromTemplate("HH:mm")

        for message in _thread.threadMessages() {
            _messages.append(message)
        }
    }
    
//    @objc public func itemCount() -> Int {
//        return _thread.threadMessages().count
//    }
    
//    @objc public func message(indexPath: IndexPath) -> Message {
//        return _thread.threadMessages()[indexPath.row]
//    }
    
    @objc public func messageTimeFormatter() -> DateFormatter {
        return _messageTimeFormatter
    }
    
    @objc public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _messages.count
    }
    
    @objc public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the message
        let message = _messages[indexPath.row]
        
        var cell: MessageCell?
        
        // Get the registration so we know which cell identifier to use
        if let registration = _messageCellRegistrations[message.messageType()] {
            let identifier = registration.identifier(direction: message.messageDirection())
            
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageCell
            cell?.setContent(content: registration.content(direction: message.messageDirection()))
            cell?.bind(message: message, model: self)
        }
        
        return cell!
    }
    
    @objc public func registerMessageCell(registration: MessageCellRegistration) {
        _messageCellRegistrations[registration.messageType()] = registration
    }

    @objc public func registerMessageCells(registrations: [MessageCellRegistration]) {
        for registration in registrations {
            registerMessageCell(registration: registration)
        }
    }

    @objc public func messageCellRegistrations() -> [MessageCellRegistration] {
        return _messageCellRegistrations.map { $1 }
    }
    
    @objc public func estimatedRowHeight() -> CGFloat {
        return 44
    }

    @objc public func avatarSize() -> CGFloat {
        return 34
    }
    
    @objc public func incomingBubbleColor() -> UIColor {
        if let color = UIColor(named: "incoming_bubble", in: bundle(), compatibleWith: nil) {
            return color
        } else if #available(iOS 13.0, *) {
            return .systemGray3
        } else {
            return .lightGray
        }
    }

    @objc public func outgoingBubbleColor() -> UIColor {
        if let color = UIColor(named: "outgoing_bubble", in: bundle(), compatibleWith: nil) {
            return color
        } else if #available(iOS 13.0, *) {
            return .systemTeal
        } else {
            return .cyan
        }
    }
    
    @objc public func showAvatar() -> Bool {
        return _thread.threadType() != .private1to1
    }
    
    @objc public func bundle() -> Bundle {
        return Bundle(for: MessagesViewModel.self)
    }

}

