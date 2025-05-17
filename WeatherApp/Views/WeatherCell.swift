import UIKit

final class WeatherCell: UITableViewCell {
    
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let iconImageView = UIImageView()
    private let dayLabel = UILabel()
    private let conditionLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let windLabel = UILabel()
    private let humidityLabel = UILabel()
    
    private let rightStack = UIStackView()
    private let leftStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        selectionStyle = .none
        contentView.backgroundColor = .systemGroupedBackground
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        dayLabel.font = .boldSystemFont(ofSize: 18)
        conditionLabel.font = .systemFont(ofSize: 14)
        conditionLabel.textColor = .darkGray
        
        temperatureLabel.font = .systemFont(ofSize: 22)
        windLabel.font = .systemFont(ofSize: 14)
        humidityLabel.font = .systemFont(ofSize: 14)
        
        leftStack.axis = .vertical
        leftStack.spacing = 4
        leftStack.addArrangedSubview(dayLabel)
        leftStack.addArrangedSubview(conditionLabel)
        
        rightStack.axis = .vertical
        rightStack.alignment = .trailing
        rightStack.spacing = 4
        rightStack.addArrangedSubview(temperatureLabel)
        rightStack.addArrangedSubview(windLabel)
        rightStack.addArrangedSubview(humidityLabel)
        
        let mainStack = UIStackView(arrangedSubviews: [iconImageView, leftStack, rightStack])
        mainStack.spacing = 12
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            mainStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            mainStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            mainStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
        ])
    }
    
    func configure(with day: ForecastDay) {
        dayLabel.text = formatDate(day.date)
        conditionLabel.text = day.day.condition.text
        temperatureLabel.text = "\(Int(day.day.avgtemp_c))°"
        windLabel.text = "\(Int(day.day.maxwind_kph)) km/h"
        humidityLabel.text = "\(Int(day.day.avghumidity))%"
        
        if let url = URL(string: "https:\(day.day.condition.icon)") {
            loadImage(from: url)
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.iconImageView.image = image
                }
            }
        }.resume()
    }
    
    private func formatDate(_ raw: String) -> String {
        if let date = ISO8601DateFormatter().date(from: raw + "T00:00:00Z") {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date).capitalized
        }
        return raw
    }
}
