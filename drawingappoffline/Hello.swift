//
//  Hello.swift
//  drawingappoffline
//
//  Created by Salvatore Fumo on 21/10/2026.
//
import SwiftUI

struct Homepage: View {
    @Binding var path: [GameScreen]

    var body: some View {
        ZStack {
            
            Image("sfondocarta")
                .resizable()
                .ignoresSafeArea()
            Image("hellogreen")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Spacer()

                Button("START") {
                    path.append(.players)
                }
                .font(.system(size: 25, weight: .heavy))
                .foregroundColor(.black)
                .padding(.vertical, 25)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(30)
            }
            .padding(.horizontal, 60)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    Homepage(path: .constant([]))
}
