//
//  meetingClass.swift
//  Audio_Recorder
//
//  Created by Max Howarth on 2018-06-14.
//  Copyright © 2018 Howarth Technologies. All rights reserved.
//

import AVFoundation
import Foundation
import Firebase
import FirebaseDatabase

class Meeting1: NSObject {
    
    // Intrinsic Meeting Properties
    let creator: String
    lazy var meetingName: String = "to be set"
    var inProgress: Bool = true
    var users = [String]()
    
    // Firebase Properties
    let firebaseMeetingDatabaseReference = Database.database().reference(withPath: "meetings")
    lazy var inProgressMeetingsDatabaseReference = firebaseMeetingDatabaseReference.child("in-progress")
    lazy var completedMeetingsDatabaseReference = firebaseMeetingDatabaseReference.child("completed")
    let firebaseStorage = Storage.storage()
    lazy var firebaseMeetingStorageReference = firebaseStorage.reference().child(meetingName)
    
    // Recorder Properties
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var onDeviceRecordingURL: URL?
    
    init(creator: String) {
        self.creator = creator
        super.init()
        meetingName = setUpMeeting()
        
    }
    

    

    

}


extension Meeting1: AVAudioRecorderDelegate {
    
    func startRecording() {
        onDeviceRecordingURL = getDocumentsDirectory().appendingPathComponent("meetingRecording.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        //MARK: Start audio recording
        
        do {
            audioRecorder = try AVAudioRecorder(url: onDeviceRecordingURL!, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        FirebaseUtilities.uploadToFirebase(fileName: self.meetingName, onDeviceFileURL: onDeviceRecordingURL!, firebaseTargetLocation: firebaseMeetingStorageReference.child(meetingName))
        
    }
    
    
}


extension Meeting1 {
    
    func setUpMeeting() -> String {
        meetingName = generateMeetingName()
        return meetingName
    }
    
    func infoForFirebase() -> Any {
        return [
            "name": meetingName,
            "creator" : creator,
            "inProgress": inProgress,
            "users": users.joined(separator: ",")]
    }
    
    func generateMeetingName() -> String {
        var values = [String]()
        var name: String = ""
        //MARK: Get list of ready names from Firebase
        firebaseMeetingDatabaseReference.child("readyNames").observeSingleEvent(of: .value, with: { (snapshot) in
            var snapshotValue = snapshot.value as! NSArray
            for value in snapshotValue {
                values.append(value as! String )
            }
            name = values[0]
            //MARK: Remove value from array, and send back to Firebase
            values.remove(at: 0)
            self.firebaseMeetingDatabaseReference.child("readyNames").setValue(values)
        })
        
        return name
    }
    
}
