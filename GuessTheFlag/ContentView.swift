//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Adalto Picotti Junior on 28/01/23.
//

import SwiftUI

struct ContentView: View {
    @State private var correctFlagAnimationAmount = 0.0
    @State private var incorrectFlagAnimationAmount = 1.0
    @State private var selectedFlagAnimationAmount = -1
    @State private var tapped = false
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var askedQuestions = 0
    @State private var isEndGame = false
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Monaco", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)],
                           center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .largeBlueTitleStyle()
                
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            // flag was tapped
                            flagTapped(number)
                        } label: {
                            FlagImage(flag: countries[number])
                        }
                        .rotation3DEffect(.degrees(number == correctAnswer ? correctFlagAnimationAmount: 0), axis: (x: 0, y: 1, z: 0))
                        .opacity(number != correctAnswer ? incorrectFlagAnimationAmount : 1.0)
                        .scaleEffect(tapped && selectedFlagAnimationAmount != number ? 0.75 : 1)
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("The game is over", isPresented: $isEndGame) {
            Button("Reset", action: reset)
        } message: {
            Text("Your score was \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            withAnimation {
                correctFlagAnimationAmount += 360
                incorrectFlagAnimationAmount = 0.25
            }
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        withAnimation {
            tapped = true
            selectedFlagAnimationAmount = number
        }
        showingScore = true
        askedQuestions += 1
    }
    
    func askQuestion() {
        if askedQuestions == 8 {
            isEndGame = true
        } else {
            countries = countries.shuffled()
            correctAnswer = Int.random(in: 0...2)
            correctFlagAnimationAmount = 0
            incorrectFlagAnimationAmount = 1.0
            selectedFlagAnimationAmount = -1
            tapped = false
        }
        
    }
    
    func reset() {
        
        correctFlagAnimationAmount = 0
        incorrectFlagAnimationAmount = 1.0
        selectedFlagAnimationAmount = -1
        tapped = false
        
        isEndGame = false
        countries = countries.shuffled()
        askedQuestions = 0
        score = 0
        
    }
    
}

struct FlagImage: View {
    var flag: String
    
    var body: some View {
        Image(flag)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ProminentBlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func largeBlueTitleStyle() -> some View {
        modifier(ProminentBlueTitle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
