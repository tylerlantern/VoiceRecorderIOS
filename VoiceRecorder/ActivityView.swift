//
//  ActivityView.swift
//  VoiceRecorder
//
//  Created by Nattapong Unaregul on 08/01/2020.
//  Copyright © 2020 Nattapong Unaregul. All rights reserved.
//

import UIKit
import SwiftUI


struct ActivityView: UIViewControllerRepresentable {
  
  let activityItems: [Any]
  let applicationActivities: [UIActivity]?
  @Binding var showing: Bool

  func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
    print(activityItems)
    let vc = UIActivityViewController(activityItems: activityItems,
                                      applicationActivities: applicationActivities)
    vc.completionWithItemsHandler = { (activityType, _, _, error) in
      self.showing = false
    }
    return vc
  }
  
  func updateUIViewController(_ uiViewController: UIActivityViewController,
                              context: UIViewControllerRepresentableContext<ActivityView>) {
    
  }
}
