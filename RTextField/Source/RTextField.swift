//
//  CustomTextField.swift
//  RTextField
//
//  Created by Rashid Latif on 04/02/2022.
//

import UIKit

@IBDesignable
class RTextField: UITextField {
    
    //  MARK: - Open variables -
//     var isSecureTextField: Bool = false
    
    //Sets hint color for not focused state
    @IBInspectable var inactiveHintColor = UIColor.gray {
        didSet { configureHint() }
    }

    //Sets hint color for focused state
    @IBInspectable  var activeHintColor = UIColor.lightGray

    //Sets background color for not focused state
    @IBInspectable  var defaultBackgroundColor = UIColor.lightGray.withAlphaComponent(0.8) {
        didSet { backgroundColor = defaultBackgroundColor }
    }

    // Sets background color for focused state
    @IBInspectable var focusedBackgroundColor = UIColor.lightGray

    //Sets border color
    @IBInspectable  var borderColor = UIColor.lightGray {
        didSet { layer.borderColor = borderColor.cgColor }
    }

   // Sets border width
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet { layer.borderWidth = borderWidth }
    }

    // Sets corner radius
    @IBInspectable  var cornerRadius: CGFloat = 5 {
        didSet { layer.cornerRadius = cornerRadius }
    }

    //Sets error color
    @IBInspectable
    open var errorColor = UIColor.red {
        didSet { errorLabel.textColor = errorColor }
    }

    override open var placeholder: String? {
        set { hintLabel.text = newValue }
        get { return hintLabel.text }
    }

    public override var text: String? {
        didSet { updateHint() }
    }

    private var isHintVisible = false
    private let hintLabel = UILabel()
    private let errorLabel = UILabel()

    private let padding: CGFloat = 16
    private let hintFont = UIFont.systemFont(ofSize: 11)

    //  MARK: Public

    public func showErrorMessage(errorString: String) {
        UIView.animate(withDuration: 0.3) {
            self.layer.borderColor = self.errorColor.cgColor
            self.errorLabel.alpha = 1
        }
        errorLabel.text = errorString
        updateErrorLabelPosition()
        errorLabel.shake(offset: 5)
    }

    public func hideError() {
        UIView.animate(withDuration: 0.3) {
            self.errorLabel.alpha = 0
        }
        errorLabel.text = nil
        updateErrorLabelPosition()
    }

    //  MARK: Private

    private func initializeTextField() {
        //remove the default placeholder
        self.borderStyle = .none
        self.attributedPlaceholder = NSAttributedString(
            string: super.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.clear]
        )
        configureTextField()
        configureHint()
        configureErrorLabel()
        addObservers()
        applyStyle()
        rightViewSetup()
    }

    private func addObservers() {
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    private func configureTextField() {
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        hintLabel.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: frame.width, height: frame.height))
        addSubview(hintLabel)
    }

    private func configureHint() {
        hintLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.updateHint()
        hintLabel.textColor = inactiveHintColor
    }

    private func updateHint() {
        if isHintVisible {
            // Small placeholder
            self.hintLabel.transform = CGAffineTransform.identity.translatedBy(x: self.padding, y: -self.hintHeight())
            self.hintLabel.font = self.hintFont
        } else if self.text?.isEmpty ?? true {
            // Large placeholder
            self.hintLabel.transform = CGAffineTransform.identity.translatedBy(x: self.padding, y: 0)
            self.hintLabel.font = self.font
        }
    }

    private func configureErrorLabel() {
        errorLabel.font = UIFont.systemFont(ofSize: 9)
        errorLabel.textAlignment = .right
        errorLabel.textColor = errorColor
        errorLabel.alpha = 0
        addSubview(errorLabel)
    }

    private func activateTextField() {
        if isHintVisible { return }
        isHintVisible.toggle()

        UIView.animate(withDuration: 0.3) {
            self.updateHint()
            self.hintLabel.textColor = self.activeHintColor
            self.backgroundColor = self.focusedBackgroundColor
//            if self.errorLabel.alpha == 0 {
                self.layer.borderColor = self.borderColor.cgColor
//            }
        }
    }

    private func deactivateTextField() {
        if !isHintVisible { return }
        isHintVisible.toggle()

        UIView.animate(withDuration: 0.3) {
            self.updateHint()
            self.hintLabel.textColor = self.inactiveHintColor
            self.backgroundColor = self.defaultBackgroundColor
            self.layer.borderColor =  self.focusedBackgroundColor.cgColor
        }
    }

    private func hintHeight() -> CGFloat {
        return hintFont.lineHeight - padding / 8
    }

    private func updateErrorLabelPosition() {
        let size = errorLabel.sizeThatFits(CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        errorLabel.frame.size = size
        errorLabel.frame.origin.x = frame.width - size.width
        errorLabel.frame.origin.y = frame.height + padding / 4
    }

    @objc private func textFieldDidChange() {
        UIView.animate(withDuration: 0.2) {
            self.errorLabel.alpha = 0
            self.layer.borderColor = self.borderColor.cgColor
        }
    }

    //  MARK: UIKit methods

    @discardableResult
    override open func becomeFirstResponder() -> Bool {
        //        self.crossButton.isHidden = false
     
        self.crossButton.transform = CGAffineTransform.identity
        hideError()
        activateTextField()
        return super.becomeFirstResponder()
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        //        self.crossButton.isHidden = true
        self.crossButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        deactivateTextField()
        return super.resignFirstResponder()
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)
        let rect = CGRect(
            x: padding,
            y: hintHeight() + 2,
            width: superRect.size.width - padding * 1.5,
            height: superRect.size.height - hintHeight()
        )
        return rect
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.editingRect(forBounds: bounds)
        let rect = CGRect(
            x: padding,
            y: hintHeight() + 2,
            width: superRect.size.width - padding * 1.5,
            height: superRect.size.height - hintHeight()
        )
        return rect
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    override open func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.clearButtonRect(forBounds: bounds)
        return superRect.offsetBy(dx: -padding / 2, dy: 0)
    }

    override open var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.size.width, height: 64)
    }

    //  MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.placeholder = super.placeholder
        initializeTextField()
        self.resignFirstResponder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.placeholder = super.placeholder
        initializeTextField()
        self.resignFirstResponder()
    }
 
    let crossButton = UIButton(type: .custom)
    let eyeButton = UIButton( type: .custom )
    private let eyeImageWidth :CGFloat = 22
    
    func applyStyle() {
        self.tintColor = UIColor(red: 94/255, green: 186/255, blue: 187/255, alpha: 1)
        self.textColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        self.inactiveHintColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1)
        self.activeHintColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1)
        self.focusedBackgroundColor = #colorLiteral(red: 0.1019608006, green: 0.1019608006, blue: 0.1019608006, alpha: 1)
        self.defaultBackgroundColor = #colorLiteral(red: 0.1019608006, green: 0.1019608006, blue: 0.1019608006, alpha: 1)
        self.borderColor = UIColor(red: 212/255, green: 108/255, blue: 43/255, alpha: 1)
        self.errorColor = UIColor.red
        self.borderWidth = 2
        self.cornerRadius = 5
        self.layer.borderColor = self.focusedBackgroundColor.cgColor
        
    }
    
    func rightViewSetup(){
        crossButton.setImage( UIImage(named: "cross.icon"), for: .normal )
        crossButton.addTarget( self, action: #selector(crossAction), for: .touchUpInside )
        crossButton.frame = CGRect( x: -5, y: 0, width: eyeImageWidth, height: self.frame.height )
        crossButton.imageView?.contentMode = .scaleAspectFit
        
        eyeButton.setImage(UIImage(named: "pass.show.icon"), for: .normal )
        eyeButton.addTarget( self, action: #selector(eyeAction), for: .touchUpInside )
        eyeButton.frame = CGRect( x: eyeImageWidth, y: 0, width: eyeImageWidth, height: self.frame.height )
        eyeButton.imageView?.contentMode = .scaleAspectFit
        
        let rightView = UIView()
        if self.isSecureTextEntry {
            rightView.frame = CGRect( x:0, y:0, width: (eyeImageWidth * 2) + 6, height: self.frame.height )
            rightView.addSubview( crossButton )
            rightView.addSubview( eyeButton )
        }else {
            rightView.frame = CGRect( x:0, y:0, width: (eyeImageWidth) , height: self.frame.height)
            rightView.addSubview( crossButton )
        }
        
        self.rightView = rightView
        self.rightViewMode = .always
    }
    
    @objc func crossAction(){
        self.text = ""
    }
    
    @objc func eyeAction(){
        self.isSecureTextEntry = !isSecureTextEntry
    }
    
}

extension UIView {
    
    func shake(offset: CGFloat = 10) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.5
        animation.values = [-offset, offset, -offset, offset, -offset/2, offset/2, -offset/4, offset/4, offset/4 ]
        layer.add(animation, forKey: "shake")
    }
}

