//
//  ViewController.swift
//  MVVMexample
//
//  Created by Pyo Cho on 2021/03/13.
//

/*:
 "우측 상단의 버튼을 누르면 셀에 '개굴' 이 표시됨" 을
 MVVM으로 만듬 을
 RxSwift 없이 개발
 
 성표, 재은, 연주, 석준
 */

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel: ViewModel = ViewModel() //bind 한거
    private let viewModel2: ViewModel2 = ViewModel2() //bind 안한거
    
    @IBAction private func requestButton(_ sender: UIBarButtonItem) {
        /*:
         이놈에 의해서 viewModel.jaeeun의 observer 가 동작함
         */
        viewModel.requestPerson()
        
        /*:
         이놈은 항상 viewModel2.requestPerson 이걸 호출해야 함.
         */
        viewModel2.requestPerson { result in
            switch result {
            case .success:
                self.tableView.reloadData()
            case .failure(let error):
                self.showAlert(error: error)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func bind() {
        viewModel.subscribe(to: viewModel.jaeeun) { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.errorEvent = { error in
            self.showAlert(error: error)
        }
    }
    
    private func showAlert(error: APIError) {
        DispatchQueue.main.async {
            guard self.presentedViewController == nil else { return }
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output(model: viewModel.jaeeun)?.count ?? .zero
//        let model = viewModel2.jaeeun.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let model = viewModel.output(model: viewModel.jaeeun)?[indexPath.row]
//        let model = viewModel2.jaeeun[indexPath.row]
        cell.textLabel?.text = model?.name
        return cell
    }
}
