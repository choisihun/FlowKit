import SwiftUI

public typealias NavigationControllerSettings = ((UIViewController) -> UINavigationController)

@available(iOS 13, *)
public final class FlowProvider: ObservableObject {
  
  var navigationController: UINavigationController
  var presenter: Presenter

  func _wrap<C: View>(_ view: C) -> UIViewController {
    UIHostingController(
      rootView: view
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(Color.black.edgesIgnoringSafeArea(.all))
    )
  }
  
  public init<C: View>(rootView: C,
                       customNavigationController: NavigationControllerSettings? = nil) {
      let hostingController = UIHostingController(rootView: rootView
                                                  .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                  .background(Color.black.edgesIgnoringSafeArea(.all)))
    navigationController = {
      if let navigationController = customNavigationController?(hostingController) {
        return navigationController
      } else {
        return UINavigationController(rootViewController: hostingController)
      }
    }()
    presenter = Presenter(navigationController: navigationController)
  }
  
  public func present() -> some View {
    presenter
  }
  
  struct Presenter: UIViewControllerRepresentable {
    
    var navigationController: UINavigationController
    
    func makeUIViewController(context: Context) -> UINavigationController {
      return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
  }
}
