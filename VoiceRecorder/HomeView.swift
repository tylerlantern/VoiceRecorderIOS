//
//  ContentView.swift
//  VoiceRecorder
//
//  Created by Nattapong Unaregul on 08/01/2020.
//  Copyright © 2020 Nattapong Unaregul. All rights reserved.
//

import SwiftUI

struct HomeView: View {
  
  let viewModel = HomeViewModel()
  
  @State var isRecording: Bool = false
  @State var isAnimating: Bool = false
  @State var isSheet : Bool = false
  @State var isPlayingVideo : Bool = false
  
  var body: some View {
    GeometryReader { proxy in
      VStack {
        ScrollView(.vertical, showsIndicators: false) {
          VStack(alignment: HorizontalAlignment.leading, spacing: 10) {
            ForEach(self.viewModel.audioFiles) { (file) in
              HStack {
                Text(file.name)
                Button(action: {
                  self.isSheet = true
                }) {Text("Save")}
//                  .sheet(isPresented: self.$isSheet) {
//                   ActivityView(activityItems: [file.url!], applicationActivities: nil,showing : self.$isSheet)
//                }
                Button(action: {
                  if self.isPlayingVideo {
                    self.viewModel.stop()
                  }else {
                    guard let url = file.url else {return}
                    self.viewModel.play(url: url, onError: nil)
                  }
                }) {
                  Text("Play").foregroundColor(Color.primary)
                }
              }.frame(width: proxy.size.width, height: 150, alignment: .center)
            }
          }
        }.frame(width: proxy.size.width, height: proxy.size.height * 0.8)
        
        Button(action: {
          if self.isRecording {
            self.isRecording = false
            self.viewModel.finishRecording()
          }else{
            self.isRecording = true
            self.viewModel.startRecording { (error) in
              self.isRecording = false
            }
          }
        }) {
          HStack {
            ActivityIndicator(isAnimating: self.isRecording) { (indicator: UIActivityIndicatorView) in
              indicator.color = .red
              indicator.hidesWhenStopped = false
            }
            Text( self.isRecording ? "Recording" : "Start Record")
          }.padding()
        }.foregroundColor(Color.blue)
      }
    }.onAppear {
      self.viewModel.setupAudioSession {error in }
    }
  }
}


struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
