//
//  ViewController.swift
//  Camera Filter
//
//  Created by Awis Alkarni on 19/03/2021.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
            let photosCVC = navC.viewControllers.first as? PhotosCollectionViewController else {
                fatalError("destination not found")
            }
        
        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
            
        }).disposed(by: disposeBag)
    }
    
    @IBAction func filterButtonPressed() {
        guard let sourceImage = self.photoImageView.image else {
            return
        }
        
        FiltersService().applyFilter(to: sourceImage)
            .subscribe(onNext: { filteredImage in
                DispatchQueue.main.async {
                    self.photoImageView.image = filteredImage
                }
            }).disposed(by: disposeBag)
    }
    
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.filterButton.isHidden = false
    }
}

