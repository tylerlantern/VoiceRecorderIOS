//
//  AudioList.swift
//  VoiceRecorder
//
//  Created by Nattapong Unaregul on 08/01/2020.
//  Copyright © 2020 Nattapong Unaregul. All rights reserved.
//
import Combine
import SwiftUI


public class AudioFile : Identifiable, ObservableObject {
  public var id = UUID()
  public let name : String
  public let url : URL?
  init(
    name: String,
    url :URL?
  ) {
    self.name = name
    self.url = url
  }
}

