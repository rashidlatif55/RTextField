// UIColor_Extension
// Created by Rashid Latif on 08/02/2022.
// Email:- rashid.latif93@gmail.com
// https://stackoverflow.com/users/10383865/rashid-latif
// https://github.com/rashidlatif55
 
import UIKit

extension UIColor {
    static let primary = UIColor(named: "Primary")!
    static let primaryDim = UIColor(named: "Primary-Dim")!
    
    static let secondary = UIColor(named: "Secondary")!
    static let secondaryDim = UIColor(named: "Secondary-Dim")!
    
    
    static let tertiary = UIColor(named: "Tertiary")!
    static let tertiaryDim = UIColor(named: "Tertiary-Dim")!
    
    static let tintPrimary = UIColor(named: "Tint-Primary")!
    static let tintPrimaryDim = UIColor(named: "Tint-Primary-Dim")!
   
    
    static let tintSecondary = UIColor(named: "Tint-Secondary")!
    static let tintSecondaryDim = UIColor(named: "Tint-Secondary-Dim")!
    
    static let tintTertiary = UIColor(named: "Tint-Tertiary")!
    static let tintTertiaryDim = UIColor(named: "Tint-Tertiary-Dim")!
    
    static let success = UIColor(named: "Success")!
    static let successDim = UIColor(named: "Success-Dim")!
    
    static let error = UIColor(named: "Error")!
    static let errorDim = UIColor(named: "Error-Dim")!
    
    static let warning = UIColor(named: "Warning")!
    static let warningDim = UIColor(named: "Warning-Dim")!
    
    static let information = UIColor(named: "Information")!
    static let informationDim = UIColor(named: "Information-Dim")!
    
    static let separator = UIColor(named: "Separator")!
    static let placeholder = UIColor(named: "Placeholder")!
    static let disabled = UIColor(named: "Disabled")!
}

extension UIColor {
    public convenience init(rgb: (r: CGFloat, g: CGFloat, b: CGFloat)) {
        self.init(red: rgb.r/255, green: rgb.g/255, blue: rgb.b/255, alpha: 1.0)
    }
}

extension UIColor{
    
    /// Converting hex string to UIColor
    ///
    /// - Parameter hexString: input hex string
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIColor {

    func convert(to color: UIColor, multiplier _multiplier: CGFloat) -> UIColor? {
        let multiplier = min(max(_multiplier, 0), 1)

        let components = cgColor.components ?? []
        let toComponents = color.cgColor.components ?? []

        if components.isEmpty || components.count < 3 || toComponents.isEmpty || toComponents.count < 3 {
            return nil
        }

        var results: [CGFloat] = []

        for index in 0...3 {
            let result = (toComponents[index] - components[index]) * abs(multiplier) + components[index]
            results.append(result)
        }

        return UIColor(red: results[0], green: results[1], blue: results[2], alpha: results[3])
    }
}
