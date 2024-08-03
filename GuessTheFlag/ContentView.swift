//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Jatin Singh on 03/08/24.
//

import SwiftUI

struct Title : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.callout)
            .bold()
            .foregroundStyle(.white)
            .fontDesign(.serif)
    }
}

struct FlagView : View {
    var flag : String
    var body: some View {
        Image(flag)
            .renderingMode(.original)
            .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                     
    }
}

struct ContentView: View {
    
    @State private var flags = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correct = Int.random(in: 0...2)
    @State private var clickResult = ""
    @State private var showAlert = false
    @State private var score = 0
    
    var body: some View {
        
            ZStack{
                RadialGradient(colors: [.white,.yellow, .black], center: .center, startRadius: 0, endRadius: 200).ignoresSafeArea()
                VStack(spacing: 40){
                    Spacer()
                    VStack(spacing: 10){
                        Text("tap the flag of")
                            .modifier(Title())
                        
                        Text("\(flags[correct])")
                            .font(.title)
                            .fontWeight(.black)
                            .modifier(Title())
                    }
                    
                    ForEach(0..<3){ number in
                        Button{
                            checkClick(number)
                        }label:{
                            FlagView(flag: flags[number])
                        }
                       
                    }
                    Spacer()
                    Text("Score : \(score)")
                        .font(.title2)
                        .modifier(Title())
                    Spacer()
                    
                }
            }
            .alert(clickResult, isPresented: $showAlert){
                Button("Continue", action: askQuestion)
            }
        
    }
    
    func checkClick(_ number: Int){
        if number == correct {
            clickResult = "Correct"
            score += 1
        }
        else {
            clickResult = "Wrong"
            score -= 1
        }
        showAlert = true
    }
    
    func askQuestion(){
        flags.shuffle()
        correct = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}
