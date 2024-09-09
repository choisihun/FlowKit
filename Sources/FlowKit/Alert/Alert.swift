import SwiftUI

@available(iOS 13, *)
public struct Alert {
  
  private let title: String
  private let message: String?
  private let buttons: [Self.Button]
  
  public init(title: String, message: String? = nil, dismissButton: Self.Button? = nil) {
    self.title = title
    self.message = message
    self.buttons = [dismissButton ?? Self.Button.default({ () -> String in
      let bundle = Bundle.init(for: UIButton.self)
      return bundle.localizedString(forKey: "확인", value: nil, table: nil)
    }())]
  }
  
  public init(title: String, message: String? = nil, primaryButton: Self.Button, secondaryButton: Self.Button) {
    self.title = title
    self.message = message
    self.buttons = [primaryButton, secondaryButton]
  }
  
  func toAlertController() -> UIAlertController {
    let alertController = UIAlertController(title: self.title,
                                            message: self.message,
                                            preferredStyle: .alert)
    self.buttons.forEach { button in
      alertController.addAction(.init(title: button.label,
                                      style: button.style,
                                      handler: { _ in
                                        Task {
                                            await button.action()
                                        }
                                      })
      )
    }
    return alertController
  }
  
  public struct Button {
    
    let label: String
    let action: @Sendable () async -> Void
    let style: UIAlertAction.Style
    
    private init(_ label: String, action: @Sendable () async -> Void, style: UIAlertAction.Style) {
      self.label = label
      self.action = action
      self.style = style
    }
    
    public static func `default`(_ label: String, action: @Sendable () async -> Void = { }) -> Alert.Button {
      Self(label, action: action, style: .default)
    }
    
    public static func cancel(_ label: String, action: @Sendable () async -> Void = { }) -> Alert.Button {
      Self(label, action: action, style: .cancel)
    }
    
    public static func cancel(_ action: @Sendable () async -> Void = { }) -> Alert.Button {
      Self.cancel({ () -> String in
        let bundle = Bundle.init(for: UIButton.self)
        return bundle.localizedString(forKey: "취소", value: nil, table: nil)
      }(), action: action)
    }
    
    public static func destructive(_ label: String, action: @Sendable () async -> Void = { }) -> Alert.Button {
      Self(label, action: action, style: .destructive)
    }
  }
}
