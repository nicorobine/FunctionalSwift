//
//  NRCoreImageFunctional.swift
//  NRSwiftFunctionalDemo
//
//  Created by NicoRobine on 2020/6/10.
//  Copyright © 2020 NicoRobine. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

typealias Filter = (CIImage) -> CIImage

func blur(radius: Double) -> Filter {
    return { image in
        let parameters: [String: Any] = [
            kCIInputRadiusKey: radius,
            kCIInputImageKey: image,
        ]
        
        guard let filter = CIFilter(name: "CIGaussianBlur", parameters: parameters) else { fatalError() }
        
        guard let outPutImage = filter.outputImage
            else { fatalError() }
        
        return outPutImage
    }
}

func generate(color: UIColor) -> Filter {
    return { _ in
        let parameters: [String: Any] = [
            kCIInputColorKey: CIColor(cgColor: color.cgColor)
        ]
        
        guard let filter = CIFilter(name: "CIConstantColorGenerator", parameters: parameters) else {
            fatalError()
        }
        
        guard let outPutImage = filter.outputImage else {
            fatalError()
        }
        
        return outPutImage
    }
}

func compositeSourceOver(overlay: CIImage) -> Filter {
    return { image in
        let parameters: [String: Any] = [
            kCIInputBackgroundImageKey: image,
            kCIInputImageKey: overlay,
        ]
        guard let filter = CIFilter(name: "CISourceOverCompositing", parameters: parameters) else {
            fatalError()
        }
        
        guard let outPutImage = filter.outputImage else {
            fatalError()
        }
        
        return outPutImage.cropped(to: image.extent)
    }
}

func overlay(color: UIColor) -> Filter {
    return { image in
        let overlay = generate(color: color)(image).cropped(to: image.extent)
        return compositeSourceOver(overlay: overlay)(image)
    }
}

func compose(filter filter1:@escaping Filter, with filter2:@escaping Filter) -> Filter {
    return {image in filter2(filter1(image))}
}

infix operator >>>

func >>>(filter1:@escaping Filter, filter2:@escaping Filter) -> Filter {
    return {image in filter2(filter1(image))}
}



