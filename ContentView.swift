import SwiftUI

struct ContentView: View {
    @StateObject private var audioEngine = AudioEngine()
    @StateObject private var hapticManager = HapticManager()
    @StateObject private var soundClassifier = SoundClassifier()
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Visualizer
            VisualizerView(audioEngine: audioEngine)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.8)
            
            VStack {
                Text("AuraCast")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                    .shadow(color: .purple, radius: 10, x: 0, y: 0)
                
                Spacer()
                
                // Sound Recognition Label
                HStack {
                    Image(systemName: "waveform.circle.fill")
                        .foregroundColor(.cyan)
                    Text(soundClassifier.detectedSound)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Material.ultraThinMaterial)
                .cornerRadius(20)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            audioEngine.start()
            soundClassifier.start()
        }
        .onDisappear {
            audioEngine.stop()
        }
        .onChange(of: audioEngine.bassIntensity) { newValue in
            hapticManager.playCombinedHaptic(bass: newValue, treble: audioEngine.trebleIntensity)
        }
    }
}
