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
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes. Top stripe blue, middle stipe black, bottom stripe white",
        "France": "Flag with three vertical stripes. Left stripe blue, middle stipe white, right stripe red",
        "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe white",
        "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe, right stripe orange",
        "Italy": "Flags with three vertical stripes. Left stripe green, middle stripe white, right stripe red",
        "Monaco": "unknown",
        "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right side green",
        "Poland": "Flag with two horizontal stripes. Top stripe red, bottom stripe white",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe is gold with crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "Ukraine": "Flag with two horizontal stipes. Top stripe blue and bottom stripe yellow",
        "US": "Flag with many red and white stripes, with white stars on a blue background in the top left corner"
    ]
    
    @State private var correct = Int.random(in: 0...2)
    @State private var clickResult = ""
    @State private var showAlert = false
    @State private var score = 0
    @State private var spinAmount = 0.0
    @State private var tappedButtonIndex : Int?
    
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
                                .rotation3DEffect(.degrees(number == correct ? spinAmount : 0), axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/)
                                .opacity(tappedButtonIndex != nil && tappedButtonIndex != number ? 0.25 : 1 )
                                .scaleEffect(tappedButtonIndex != nil && tappedButtonIndex != number ? 0.75 : 1)
                        }
                        .accessibilityLabel(labels[flags[number], default: "Unknown Flag"])
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
        tappedButtonIndex = number
        if number == correct {
            withAnimation(.easeIn(duration: 0.5)){
                spinAmount += 360
                clickResult = "Correct"
                score += 1
            }
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
        tappedButtonIndex = nil
    }
}

#Preview {
    ContentView()
}
