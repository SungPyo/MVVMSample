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
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel: ViewModel = ViewModel()
    let viewModel2: ViewModel2 = ViewModel2()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    func bind() {
        /*:
         클로저를 동작하게 하는 장치는 -> viewModel.requestPerson
         어디서든 viewModel.requestPerson 를 호출하면 클로저가 동작함.
         */
        viewModel.subscribe(to: viewModel.jaeeun) { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func showAlert(error: APIError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func requestButton(_ sender: UIBarButtonItem) {
        viewModel.requestPerson { error in
            self.showAlert(error: error)
        }
        
        /*:
         이놈은 항상 viewModel2.requestPerson 이걸 호출해야 함.
         */
        viewModel2.requestPerson { result in
            switch result {
            case .success:
                self.tableView.reloadData()
            case .failure(let error):
                print("error = \(error)")
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.jaeeun.event?.count ?? .zero
//        return viewModel2.jaeeun.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let person = viewModel.jaeeun.event?[indexPath.row]
//        let person = viewModel2.jaeeun[indexPath.row]
        cell.textLabel?.text = person?.name
        return cell
    }
}
