
import UIKit
import SwiftUI

public struct ActivityIndicator: UIViewRepresentable {

    public typealias UIView = UIActivityIndicatorView
    public var isAnimating: Bool
    public var configuration = { (indicator: UIView) in }

  public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView { UIView() }
  public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Self>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        configuration(uiView)
    }
}

extension View where Self == ActivityIndicator {
    func configure(_ configuration: @escaping (Self.UIView)->Void) -> Self {
        Self.init(isAnimating: self.isAnimating, configuration: configuration)
    }
}
