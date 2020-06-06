//
//  RPViewController.swift
//  RangParivartan
//
//  Created by Ravi Shankar Kushwaha on 06/06/20.
//  Copyright © 2020 Self. All rights reserved.
//

import UIKit

public protocol RPControllerDelegate {
    func rPControllerImageDidFilter(image: UIImage)
    func rPControllerDidCancel()
}

public class RPViewController: UIViewController {

     @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var appliedFilterName: UILabel!
    private var filterIndex = 0
    var image: UIImage?
    fileprivate var smallImage:UIImage?
    fileprivate var smallImageList:[UIImage] = []
    fileprivate let context = CIContext()
    fileprivate let filterList = [
        "Default", "CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectMono",        "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal",       "CIPhotoEffectTransfer","CISepiaTone", "CIVignette", "CIGaussianBlur",      "CIUnsharpMask","CINoiseReduction", "CIColorClamp", "CIColorControls", "CIColorMatrix",
            "CIColorPolynomial","CIExposureAdjust", "CIGammaAdjust", "CIHueAdjust", "CILinearToSRGBToneCurve", "CISRGBToneCurveToLinear", "CITemperatureAndTint", "CIToneCurve", "CIVibrance", "CIWhitePointAdjust", "CIColorCrossPolynomial", "CIColorCube", "CIColorCubeWithColorSpace", "CIColorInvert", "CIColorMonochrome", "CIColorPosterize", "CIFalseColor",    "CISharpenLuminance", "CIBloom", "CIComicEffect", "CIDepthOfField", "CIEdges", "CIGloom", "CIHexagonalPixellate", "CIHighlightShadowAdjust", "CISpotColor"]
    
    
    fileprivate let displayNameOfFilterList = [ "Default", "Chrome", "Fade", "Instant", "Mono", "Noir", "Process", "Tonal", "Transfer", "Sepia", "Vignette", "GaussianBlur",  "UnsharpMask", "NoiseReduction", "ColorClamp", "ColorControls", "ColorMatrix","ColorPolynomial", "ExposureAdjust", "GammaAdjust", "HueAdjust", "LinearToToneCurve", "ToneCurveToLinear", "TemperatureAndTint", "ToneCurve", "Vibrance", "WhitePointAdjust", "CrossPolynomial", "Cube", "CubeWithSpace", "Invert", "Monochrome", "Posterize", "FalseColor", "SharpenLuminance", "Bloom", "ComicEffect", "DepthOfField", "Edges", "Gloom", "HexagonalPixellate", "HighlightShadowAdjust", "SpotColor"
    ]
    
    public var delegate:RPControllerDelegate?
    
    public init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        if let view = UINib(nibName: "RPViewController", bundle: Bundle(for: self.classForCoder)).instantiate(withOwner: self, options: nil).first as? UIView {
            self.view = view
            if let image = self.image {
                imageView?.image = image
            }
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        doneButton.layer.cornerRadius = 25
        cancelButton.layer.cornerRadius = 25
        
        collectionView?.register(UINib(nibName: "RPCollectionViewCell", bundle: Bundle(for: self.classForCoder)), forCellWithReuseIdentifier: "cell")
        //Collection View Settings
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: 100, height: 140)
        collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        collectionViewFlowLayout.minimumInteritemSpacing = 5
        collectionViewFlowLayout.minimumLineSpacing = 5
        processSmallImage()
    }
    
    func processSmallImage() {
        if let imageObj = self.image {
                   self.imageView.image = imageObj
                   DispatchQueue.global().async {
                       self.smallImage = self.resizedImage(at: imageObj, scale: 0.3)
                       if let smallImageObj = self.smallImage {
                           self.smallImageList.append(smallImageObj)
                           for filterName in self.filterList {
                               if filterName != "Default"{
                                   self.smallImageList.append(self.getFilteredImage(of: smallImageObj, with: filterName)!)
                                   DispatchQueue.main.async {
                                       self.collectionView.reloadData()
                                   }
                               }
                           }
                       }
                   }
               }
    }

    @IBAction func doneAction(_ sender: Any) {
        if let delegate = self.self.delegate {
            delegate.rPControllerImageDidFilter(image: self.imageView.image!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        if let delegate = self.self.delegate {
            delegate.rPControllerDidCancel()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func appliyFilter() {
        if let imageObj = self.image {
            if filterIndex != 0 {
                self.imageView.image = getFilteredImage(of: imageObj, with: filterList[filterIndex])
            } else {
                self.imageView.image = imageObj
            }
        }
        
        self.appliedFilterName.text = displayNameOfFilterList[filterIndex]
    }
    
    func getFilteredImage(of sourceImage: UIImage, with filterName:String) -> UIImage? {
        
        let image = CIImage(cgImage: sourceImage.cgImage!)
        
        let filter = CIFilter(name: filterName)!
        filter.setDefaults()
        
        filter.setValue(image, forKey: kCIInputImageKey)
    
        guard let outputCIImage = filter.outputImage, let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent)
        else {
            return nil
        }
        return UIImage(cgImage: outputCGImage)
    }
    
    func resizedImage(at image:UIImage, scale: CGFloat) -> UIImage? {
       
        let ciImage = CIImage(cgImage: image.cgImage!)
        let aspectRatio = image.size.width / image.size.height
        
        let filter = CIFilter(name: "CILanczosScaleTransform")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(scale, forKey: kCIInputScaleKey)
        filter?.setValue(aspectRatio, forKey: kCIInputAspectRatioKey)

        guard let outputCIImage = filter?.outputImage, let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent)
        else {
            return nil
        }

        return UIImage(cgImage: outputCGImage)
    }

}


extension  RPViewController: UICollectionViewDataSource, UICollectionViewDelegate
{
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RPCollectionViewCell
        cell.filterName.text = displayNameOfFilterList[indexPath.row]
        cell.imageView.image = self.smallImageList[indexPath.row]
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.smallImageList.count
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.filterIndex = indexPath.row
        self.appliyFilter()
    }
}
