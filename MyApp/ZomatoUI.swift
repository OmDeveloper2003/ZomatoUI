import SwiftUI
import CoreMotion

struct ZomatoUI: View {
    let imageList = ["food1", "food2", "food3", "DhosaImg", "MaskGroup"]
    let nameList = ["Healthy", "Home Style", "Pizza", "Chicken", "Fast Food"]
    
    @State private var selectedRating: Double = 4.0
    @State private var showDetails = false
    @State private var selectedRestaurant = ""
    @State private var favorites: [String] = []
    @State private var randomRestaurant: String?
    
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    HeaderView()
                    BannerView()
                    Text("Eat What Makes you Happy")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.vertical)
                    CategoryListView(imageList: imageList, nameList: nameList)
                    RestaurantInfoView(selectedRating: $selectedRating)
                    RatingSliderView(selectedRating: $selectedRating)
                    PromotionView(showDetails: $showDetails, selectedRestaurant: $selectedRestaurant, favorites: $favorites)
                    if showDetails {
                        RestaurantDetailsView(selectedRestaurant: selectedRestaurant, favorites: $favorites)
                            .transition(.move(edge: .bottom))
                    }
                    if let randomRestaurant = randomRestaurant {
                        RandomRestaurantView(randomRestaurant: randomRestaurant)
                            .transition(.scale)
                    }
                }
                .padding()
                .onAppear {
                    startShakeDetection()
                }
                .onDisappear {
                    stopShakeDetection()
                }
            }
            .background(Color(UIColor.systemGray6))
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .animation(.easeInOut, value: showDetails)
        }
    }
    
    private func startShakeDetection() {
        motionManager.startAccelerometerUpdates(to: queue) { (data, error) in
            guard let data = data else { return }
            
            if abs(data.acceleration.x) > 2.5 ||
               abs(data.acceleration.y) > 2.5 ||
               abs(data.acceleration.z) > 2.5 {
                DispatchQueue.main.async {
                    suggestRandomRestaurant()
                }
            }
        }
    }
    
    private func stopShakeDetection() {
        motionManager.stopAccelerometerUpdates()
    }
    
    private func suggestRandomRestaurant() {
        let restaurants = ["Healthy Delight", "Home Style Cooking", "Pizza Place", "Chicken Corner", "Fast Food Hub"]
        randomRestaurant = restaurants.randomElement()
        
        // Dismiss suggestion after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            randomRestaurant = nil
        }
    }
}

struct HeaderView: View {
    var body: some View {
        HStack {
            Circle()
                .fill(Color.red)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "location.fill")
                        .foregroundColor(.white)
                )
            VStack(alignment: .leading) {
                Text("Home")
                    .font(.headline)
                Text("Karol Bagh, New Delhi")
                    .font(.subheadline)
            }
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.title)
                .foregroundColor(.red)
            Image("clutchcoderlogo")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        }
        .padding(.top)
    }
}

struct BannerView: View {
    var body: some View {
        Image("Zomato1")
            .resizable()
            .scaledToFit()
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.vertical)
                }
            }

            struct CategoryListView: View {
                let imageList: [String]
                let nameList: [String]
                
                var body: some View {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(0..<imageList.count, id: \.self) { index in
                                VStack {
                                    Image(imageList[index])
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                    Text(nameList[index])
                                        .fontWeight(.medium)
                                }
                                .transition(.scale)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }

            struct RestaurantInfoView: View {
                @Binding var selectedRating: Double
                
                var body: some View {
                    HStack {
                        Text("\(Int.random(in: 100...200)) restaurants around you")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        HStack {
                            Image(systemName: "chart.bar")
                            Text("Popular")
                        }
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(8)
                    }
                }
            }

            struct RatingSliderView: View {
                @Binding var selectedRating: Double
                
                var body: some View {
                    VStack {
                        Text("Filter by Rating")
                            .font(.headline)
                        Slider(value: $selectedRating, in: 0...5, step: 0.1)
                            .accentColor(.red)
                        Text(String(format: "Rating: %.1f+", selectedRating))
                            .font(.subheadline)
                    }
                    .padding(.vertical)
                }
            }

            struct PromotionView: View {
                @Binding var showDetails: Bool
                @Binding var selectedRestaurant: String
                @Binding var favorites: [String]
                
                var body: some View {
                    ZStack(alignment: .topLeading) {
                        Image("Zomato2")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .onTapGesture {
                                withAnimation {
                                    selectedRestaurant = "Sultan Kacchi Biryani"
                                    showDetails.toggle()
                                }
                            }
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Promoted")
                                    .padding(8)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                Spacer()
                                FavoriteButton(isFavorite: favorites.contains("Sultan Kacchi Biryani")) {
                                    if favorites.contains("Sultan Kacchi Biryani") {
                                        favorites.removeAll { $0 == "Sultan Kacchi Biryani" }
                                    } else {
                                        favorites.append("Sultan Kacchi Biryani")
                                    }
                                }
                            }
                            Spacer()
                            HStack {
                                Text("70% OFF")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                                Spacer()
                                HStack {
                                    Image(systemName: "bicycle")
                                    Text("25 mins")
                                }
                                .padding(8)
                                .background(Color.white)
                                .cornerRadius(8)
                            }
                        }
                        .padding()
                    }
                    .frame(height: 200)
                }
            }

            struct RestaurantDetailsView: View {
                var selectedRestaurant: String
                @Binding var favorites: [String]
                
                var body: some View {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(selectedRestaurant)
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                            FavoriteButton(isFavorite: favorites.contains(selectedRestaurant)) {
                                if favorites.contains(selectedRestaurant) {
                                    favorites.removeAll { $0 == selectedRestaurant }
                                } else {
                                    favorites.append(selectedRestaurant)
                                }
                            }
                        }
                        HStack {
                            Text("Biryani, Desserts, Kacchi")
                            Spacer()
                            Text("Price Range 250 - 550")
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.vertical)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
            }

            struct RandomRestaurantView: View {
                var randomRestaurant: String
                
                var body: some View {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("We recommend trying:")
                            .font(.headline)
                        Text(randomRestaurant)
                            .font(.title)
                            .fontWeight(.bold)
                        HStack {
                            Text("Randomly selected just for you!")
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.vertical)
                }
            }

            struct FavoriteButton: View {
                var isFavorite: Bool
                var action: () -> Void
                
                var body: some View {
                    Button(action: action) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .gray)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                }
            }
