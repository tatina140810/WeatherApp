import UIKit

final class WeatherViewController: UIViewController, UITableViewDataSource {
    
    private let viewModel = WeatherViewModel()
    private let tableView = UITableView()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Moscow"
        return label
    }()
    private let forecastLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5 - Day Forecast "
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        bindViewModel()
        viewModel.fetchWeather(for: "moscow")
        setupUI()
    }
    private func setupUI(){
        view.addSubview(locationLabel)
        view.addSubview(tableView)
        view.addSubview(forecastLabel)
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forecastLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 24),
            forecastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: forecastLabel.bottomAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
    }
    private func setupTableView(){
        tableView.dataSource = self
        tableView.register(WeatherCell.self, forCellReuseIdentifier: "WeatherCell")
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.onError = { errorMessage in
            print("Ошибка: \(errorMessage)")
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.forecast.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherCell else {
            return UITableViewCell()
        }
        let day = viewModel.forecast[indexPath.row]
        cell.configure(with: day)
        
        return cell
    }
    
    
}

