//
//  ContentView.swift
//  hw1
//
//  Created by 楊鈞安 on 2025/2/28.
//

import SwiftUI

enum UNIT: String, CaseIterable{
    case Celsius = "Celsius"
    case Fahrenheit = "Fahrenheit"
}


struct ContentView: View {
    @FocusState private var isFocused: Bool
    @State private var inputUnit:UNIT = .Celsius
    @State private var outputUnit:UNIT = .Fahrenheit
    @State private var inputTemper: Double = 0.0
    @State private var outputTemper: Double = 0.0
    @State private var background: LinearGradient = LinearGradient(gradient: Gradient(colors: [.white]),
                                                                   startPoint: .top, endPoint: .bottom)
    
    let numberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            return formatter
        }()
    
    var body: some View {
        NavigationView {
            ZStack {
                background
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    SectionView(title: "Input") {
                        Picker("Input unit", selection: $inputUnit) {
                            ForEach(UNIT.allCases, id: \.self) { units in
                                Text(units.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: inputUnit) {
                            outputUnit = (inputUnit == .Celsius) ? .Fahrenheit : .Celsius
                            calculateTargetTemperature()
                        }
                        
                        TextField("Input Temperature", value: $inputTemper, formatter: numberFormatter)
                            .keyboardType(.default)
                            .focused($isFocused)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(
                                            HStack {
                                                Spacer()
                                                Text((inputUnit == .Celsius) ? "°C" : "°F")
                                                    .padding(.trailing, 8)
                                            }
                                        )
                            .padding()
                            .onChange(of:inputTemper){
                                calculateTargetTemperature()
                            }
                    }
                    SectionView(title: "Output") {
                        Picker("Output unit", selection: $outputUnit) {
                            ForEach(UNIT.allCases, id: \.self) { units in
                                Text(units.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: outputUnit) {
                            inputUnit = (outputUnit == .Celsius) ? .Fahrenheit : .Celsius
                            calculateTargetTemperature()
                        }
                        HStack {
                            Text("Converted Temperature: \(outputTemper, specifier: "%.2f")")
                            Text((outputUnit == .Celsius) ? "°C" : "°F")
                                .padding(.leading, 4)
                        }
                        .padding()
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding()
            }
            .navigationBarTitle("Temperature Conversion", displayMode: .inline)
            .toolbar{
                if isFocused{
                    Button("Done"){
                        isFocused = false
                    }
                }
            }
            .onChange(of: inputTemper ) {
                withAnimation(){
                    updateBackgroundColor(for: (inputUnit == .Celsius) ?
                                          inputTemper : outputTemper)
                }
            }
            .onChange(of: outputTemper) {
                withAnimation(){
                    updateBackgroundColor(for: (inputUnit == .Celsius) ?
                                          inputTemper : outputTemper)
                }
            }
        }
        .background(background)
        .onAppear {
                    updateBackgroundColor(for: inputTemper)
                }
    }

    func SectionView<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        return VStack(alignment: .center) {
            Text(title)
                .font(.headline)
                .padding()
            content()
        }
    }

    func changeUnit(for unit: UNIT){
        if(unit == outputUnit){
            inputUnit = (outputUnit == .Celsius) ? .Fahrenheit : .Celsius
            updateBackgroundColor(for: (inputUnit == .Celsius) ?
                                  inputTemper : outputTemper)
        }else{
            outputUnit = (inputUnit == .Celsius) ? .Fahrenheit : .Celsius
            updateBackgroundColor(for: (inputUnit == .Celsius) ?
                                  inputTemper : outputTemper)
        }
        calculateTargetTemperature()
        
    }
    func calculateTargetTemperature() {
        if inputUnit == .Celsius {
            outputTemper = (inputTemper * 9/5) + 32
        } else {
            outputTemper = (inputTemper - 32) * 5/9
        }
        withAnimation {
               updateBackgroundColor(for: (inputUnit == .Celsius) ? inputTemper : outputTemper)
           }
    }
    func updateBackgroundColor(for temp: Double) {
        
        let normalizedTemperature = min(max(temp, -50), 50)
        
        let colorStart = Color.blue.opacity(1 - (normalizedTemperature + 50) / 100)
        let colorEnd = Color.red.opacity((normalizedTemperature + 50) / 100)
        
        background = LinearGradient(gradient: Gradient(colors: [colorStart, colorEnd]),
                                    startPoint: .top,
                                    endPoint: .bottom)
    }
}

#Preview {
    ContentView()
}
