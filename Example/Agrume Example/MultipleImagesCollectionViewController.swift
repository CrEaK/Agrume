//
//  Copyright © 2016 Schnaub. All rights reserved.
//

import Agrume
import UIKit

final class MultipleImagesCollectionViewController: UICollectionViewController {

  private let identifier = "Cell"

  private let images = [
    UIImage(named: "MapleBacon")!,
    UIImage(named: "EvilBacon")!
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
    layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
  }

  // MARK: UICollectionViewDataSource

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    images.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! DemoCell
    cell.imageView.image = images[indexPath.item]
    return cell
  }

  // MARK: UICollectionViewDelegate

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let agrume = Agrume(images: images, startIndex: indexPath.item, background: .blurred(.regular))
    agrume.didScroll = { [unowned self] index in
      self.collectionView?.scrollToItem(at: IndexPath(item: index, section: 0), at: [], animated: false)
    }
    let helper = makeHelper()
    agrume.onLongPress = helper.makeSaveToLibraryLongPressGesture
    agrume.show(from: self)
  }
  
  private func makeHelper() -> AgrumePhotoLibraryHelper {
    let saveButtonTitle = NSLocalizedString("Save Photo", comment: "Save Photo")
    let cancelButtonTitle = NSLocalizedString("Cancel", comment: "Cancel")
    let helper = AgrumePhotoLibraryHelper(saveButtonTitle: saveButtonTitle, cancelButtonTitle: cancelButtonTitle) { error in
      guard error == nil else {
        print("Could not save your photo")
        return
      }
      print("Photo has been saved to your library")
    }
    return helper
  }
}
