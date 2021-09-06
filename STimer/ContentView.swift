//
//  ContentView.swift
//  STimer
//
//  Created by Anna on 11.06.2021.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    @ObservedObject var timerManager = TimerManager()
    
    var body: some View {
        
        ZStack {
            Color(red: 0.09, green: 0.63, blue: 0.52)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                Text(timerManager.getTimerString())
                    .font(Font.custom("HelveticaNeue-UltraLight", size: 60))
                    .fontWeight(.regular)
                    .foregroundColor(Color(red: 0.93, green: 0.94, blue: 0.95))
                    
                Spacer()
                    .frame(height: 120.0)
                Button(action: {
                    timerManager.timerIsRun ? timerManager.stopTimer() : timerManager.startTimer()
                    print(Realm.Configuration.defaultConfiguration.fileURL)
                }) {
                    mainButton(state: timerManager.timerIsRun)
                }

                Spacer()
                    .frame(height: 50)
                Button(action: {
                    timerManager.saveTimeButton()
                }) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .foregroundColor(Color(red: 0.93, green: 0.94, blue: 0.95))
                        .frame(width: 50, height: 50)
                        .imageScale(.small)
                        
                }
            }
        }
    }
    
    class TimerManager: ObservableObject {
        
        let realm = try! Realm()
        
        @Published var timerIsRun: Bool = false
        @Published var time: Int = 0
        var timer: Timer? = nil
        var currentTimes = [Int]()
        var timeStamps: Results<TimeStamp>?
        
        
        func getTimerString() -> String {
            
            let seconds: Int = time % 60
            let minutes: Int = time / 60
            let hours: Int = minutes / 60
            
            var secondsString: String {
                seconds > 9 ? "\(seconds)" : "0\(seconds)"
            }
            var minuteString: String {
                minutes > 9 ? "\(minutes)" : "0\(minutes)"
            }
            var hoursString: String {
                hours > 9 ? "\(hours)" : "0\(hours)"
            }
            
            return "\(hoursString) : \(minuteString) : \(secondsString)"
        }
        
        func startTimer() {
            timerIsRun = true
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { tempTimer in
                
                DispatchQueue.main.async { //need more thinking
                    self.time += 1
                }
            }
        }
        
        func stopTimer() {
            timerIsRun = false
            timer?.invalidate()
            timer = nil
        }
        
        func saveTimeButton() {
            timerIsRun = false
            timer?.invalidate()
            timer = nil
            currentTimes.append(time)
            time = 0
            
            let totalTime = currentTimes.reduce(0, +)
            
            do {
                try self.realm.write {
                    let newTimeStamp = TimeStamp()
                    newTimeStamp.time = totalTime
                    newTimeStamp.date = NSDate()
                    realm.add(newTimeStamp)
                }
            } catch {
                print("Error saving new timestamp: \(error)")
            }
            
            print(currentTimes.reduce(0, +))
        }
    }
}


struct mainButton: View {
    
    let state: Bool
    var label: String {
        state ? "Stop" : "Start"
    }
    var buttonColor: Color {
        state ? Color(red: 0.74, green: 0.76, blue: 0.78) : Color(red: 0.95, green: 0.77, blue: 0.06)
    }
    
    var body: some View {
        Text(label)
            .font(.system(size: 50))
            .fontWeight(.bold)
            .foregroundColor(Color(red: 0.20, green: 0.29, blue: 0.37))
            .padding(.all, 65.0)
            .background(buttonColor)
            .clipShape(Circle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
