import SwiftUI

@available(iOS 13, *)
public extension FlowProvider {

  fileprivate func _wrap<C: View>(_ view: C) -> UIViewController {
    UIHostingController(rootView: view)
  }
  // MARK: - Push View
  func push<C: View>(_ view: C, animated: Bool = true) {
    Task {
      await MainActor.run {
        navigationController.pushViewController(_wrap(view), animated: animated)
      }
    }
  }
  
  // MARK: - Pop View
  func pop(animated: Bool = true) {
    Task {
      await MainActor.run {
        navigationController.popViewController(animated: animated)
      }
    }
  }
  
  // MARK: - Pop View with Specific Count
  func pop(_ count: Int, animated: Bool = true) {
    Task {
      await MainActor.run {
        let viewControllers = navigationController.viewControllers
        let index = viewControllers[viewControllers.count - count]
        navigationController.popToViewController(index, animated: animated)
      }
    }
  }
  
  // MARK: - Pop View to Root
  func popToRoot(animated: Bool = true) {
    Task {
      await MainActor.run {
        navigationController.popToRootViewController(animated: animated)
      }
    }
  }
  
  // MARK: - Replace View
  func replace<C: View>(_ views: [C], animated: Bool = true) {
    Task {
      await MainActor.run {
        let viewControllers = views.map { _wrap($0) }
        navigationController.setViewControllers(viewControllers, animated: animated)
      }
    }
  }
  
  // MARK: - Reload View
  func reload(animated: Bool = false) {
    Task {
      await MainActor.run {
        let lastViewController = navigationController.topViewController
        var currentViewControllers: [UIViewController] {
          navigationController.viewControllers.dropLast()
        }
        if let lastViewController {
          let viewControllers = currentViewControllers + [lastViewController]
          navigationController.setViewControllers(viewControllers, animated: animated)
        }
      }
    }
  }
  
  // MARK: - Sheet
  func sheet<C: View>(_ view: C, animated: Bool = true) {
    Task {
      await MainActor.run {
        navigationController.present(_wrap(view), animated: animated)
      }
    }
  }
    
  // MARK: - FullScreenSheet
  func fullScreenSheet<C: View>(_ view: C, animated: Bool = true) {
    Task {
      await MainActor.run {
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.present(_wrap(view), animated: animated)
        print(navigationController.modalPresentationStyle)
      }
    }
  }

  // MARK: - Alert
  func alert(_ alert: Alert, animated: Bool = true) {
    Task {
      await MainActor.run {
        navigationController.present(alert.toAlertController(), animated: animated)
      }
    }
  }
}
