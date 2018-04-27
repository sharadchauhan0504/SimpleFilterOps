//
//  EditImageOperations.swift
//  FilterOps
//
//  Created by Sharad on 24/01/18.
//

import UIKit
import CoreImage

@objc class EditImageOperations: NSObject {
    
    @objc static let shared = EditImageOperations()
    
    var aCIImage = CIImage()
    
    // List of Filters
    var contrastFilter: CIFilter!
    var brightnessFilter: CIFilter!
    var saturationFilter : CIFilter!
    var blurFilter: CIFilter!
    var shapnessFilter: CIFilter!
    
    var context = CIContext()
    var outputImage = CIImage()
    var newUIImage = UIImage()
    
    var originalImage = UIImage()
    
    @objc func initialize(imageView: UIImageView){
        guard let image = imageView.image else {
            return
        }
        
        originalImage    = image
        let aUIImage     = image
        
        guard let aCGImage     = aUIImage.cgImage else { return }
        
        aCIImage         = CIImage.init(cgImage: aCGImage)
        context          = CIContext(options: nil)
        
        contrastFilter   = CIFilter(name: "CIColorControls")
        contrastFilter.setValue(aCIImage, forKey: "inputImage")
        
        brightnessFilter = CIFilter(name: "CIColorControls")
        brightnessFilter.setValue(aCIImage, forKey: "inputImage")
        
        saturationFilter = CIFilter(name: "CIColorControls")
        saturationFilter.setValue(aCIImage, forKey: "inputImage")
        
        blurFilter       = CIFilter(name: "CIGaussianBlur")!
        blurFilter.setValue(aCIImage, forKey: "inputImage")
        
        shapnessFilter   = CIFilter(name: "CISharpenLuminance")
        shapnessFilter.setValue(aCIImage, forKey: "inputImage")
        
    }
    
    @objc func getOriginalImage() -> UIImage{
        return originalImage
    }
    
    @objc func imageBrightness(sliderValue : Float) -> UIImage{
        
        print(" Brightness sliderValue : \(sliderValue)")
        brightnessFilter.setValue(sliderValue, forKey: kCIInputBrightnessKey)
        outputImage  = brightnessFilter.outputImage!;
        let imageRef = context.createCGImage(outputImage, from: aCIImage.extent)
        newUIImage   = UIImage(cgImage: imageRef!)
        
        return newUIImage
    }
    
    @objc func imageContrast(sliderValue: Float) -> UIImage{
        print(" Contrast sliderValue : \(sliderValue)")
        contrastFilter.setValue(sliderValue, forKey: kCIInputContrastKey)
        outputImage = contrastFilter.outputImage!
        let cgimg   = context.createCGImage(outputImage, from: aCIImage.extent)
        newUIImage  = UIImage(cgImage: cgimg!)
        
        return newUIImage
    }
    
    @objc func imageSaturation(sliderValue: Float) -> UIImage{
        print(" Contrast sliderValue : \(sliderValue)")
        saturationFilter.setValue(sliderValue, forKey: kCIInputSaturationKey)
        outputImage = saturationFilter.outputImage!
        let cgimg   = context.createCGImage(outputImage, from: aCIImage.extent)
        newUIImage  = UIImage(cgImage: cgimg!)
        
        return newUIImage
    }
    
    @objc func imageBlur(sliderValue: Float) -> UIImage{
        print(" Blur sliderValue : \(sliderValue)")
        blurFilter.setValue(sliderValue, forKey: kCIInputRadiusKey)
        outputImage = blurFilter.outputImage!
        let cgimg   = context.createCGImage(outputImage, from: aCIImage.extent)
        newUIImage  = UIImage(cgImage: cgimg!)
        
        return newUIImage
    }
    
    @objc func imageSharpness(sliderValue: Float) -> UIImage{
        print(" Blur sliderValue : \(sliderValue)")
        shapnessFilter.setValue(sliderValue, forKey: kCIInputRadiusKey)
        outputImage = shapnessFilter.outputImage!
        
        let cgimg   = context.createCGImage(outputImage, from: aCIImage.extent)
        newUIImage  = UIImage(cgImage: cgimg!)
        
        return newUIImage
    }
    
    @objc func mergeImages (forgroundImage : UIImage, backgroundImage : UIImage, size : CGSize) -> UIImage {
        
        let bottomImage = backgroundImage
        UIGraphicsBeginImageContext(size)
        
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        bottomImage.draw(in: areaSize)
        
        let topImage      = forgroundImage
        topImage.draw(in: areaSize, blendMode: .normal, alpha: 1.0)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
