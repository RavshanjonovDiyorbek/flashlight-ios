import SwiftUI
import AVFoundation

@main
struct FlashlightApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var isLightOn = false
    @State private var brightness: Float = 1.0

    var body: some View {
        ZStack {
            (isLightOn ? Color.yellow.opacity(0.15) : Color.black)
                .ignoresSafeArea()

            VStack(spacing: 35) {
                Image(systemName: isLightOn ? "flashlight.on.fill" : "flashlight.off.fill")
                    .font(.system(size: 80))
                    .foregroundColor(isLightOn ? .yellow : .gray)

                Button(action: {
                    isLightOn.toggle()
                    setTorch(on: isLightOn, level: brightness)
                }) {
                    Text(isLightOn ? "O'chirish" : "Yoqish")
                        .font(.title2.bold())
                        .foregroundColor(.black)
                        .frame(width: 200, height: 55)
                        .background(isLightOn ? Color.yellow : Color.white)
                        .cornerRadius(14)
                }

                if isLightOn {
                    VStack(spacing: 10) {
                        Text("Yorug'lik: \(Int(brightness * 100))%")
                            .foregroundColor(.white)
                            .font(.subheadline)

                        Slider(value: Binding(
                            get: { brightness },
                            set: { newValue in
                                brightness = newValue
                                setTorch(on: true, level: newValue)
                            }
                        ), in: 0.1...1.0)
                        .accentColor(.yellow)
                        .padding(.horizontal, 40)
                    }
                }
            }
        }
    }

    private func setTorch(on: Bool, level: Float) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            if on {
                try device.setTorchModeOn(level: level)
            } else {
                device.torchMode = .off
            }
            device.unlockForConfiguration()
        } catch {
            print("Xatolik: \(error.localizedDescription)")
        }
    }
}