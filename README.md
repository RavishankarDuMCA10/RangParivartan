# RangParivartan

# Usage
## How to present RPViewController

```Swift
let image = UIImage(named: "targetImage")
let vc = RPViewController(image: image)
vc.delegate = self
self.present(vc, animated:true, completion: nil)
```
## RPControllerDelegate methods

extension ViewController: RPControllerDelegate {
    func rPControllerImageDidFilter(image: UIImage) {
      // Filtered image will be returned here.
    }

   func rPControllerDidCancel() {
      // This will be called when you cancel filtering the image.
    }
}
