//
//  CustomTextField.swift
// Created by Rashid Latif on 08/02/2022.
// Email:- rashid.latif93@gmail.com
// https://stackoverflow.com/users/10383865/rashid-latif
// https://github.com/rashidlatif55


import UIKit

@IBDesignable
class RTextField: UITextField {
    
    //  MARK: - Open variables -
    
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
    @IBInspectable  var customBorderColor = UIColor.lightGray {
        didSet { layer.borderColor = customBorderColor.cgColor }
    }
    
    // Sets border width
    @IBInspectable var customBorderWidth: CGFloat = 1.0 {
        didSet { layer.borderWidth = customBorderWidth }
    }
    
    // Sets corner radius
    @IBInspectable  var customCornerRadius: CGFloat = 5 {
        didSet { layer.cornerRadius = customCornerRadius }
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
        hintLabel.textColor = .error
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
        layer.borderWidth = customBorderWidth
        layer.cornerRadius = customCornerRadius
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
            self.layer.borderColor = self.customBorderColor.cgColor
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
            self.layer.borderColor = self.customBorderColor.cgColor
        }
    }
    
    //  MARK: UIKit methods
    
    @discardableResult
    override open func becomeFirstResponder() -> Bool {
        //        self.crossButton.isHidden = false
        self.crossButton.transform = CGAffineTransform.identity
        hideError()
        activateTextField()
        //bring cursor to end of string
        DispatchQueue.main.async {
            let endPosition = self.endOfDocument
            self.selectedTextRange = self.textRange(from: endPosition, to: endPosition)
        }
        return super.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        //        self.crossButton.isHidden = true
        hideError()
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
    
    private let buttonsImageWidth :CGFloat = 25
    
    func applyStyle() {
        self.tintColor = UIColor.tintSecondary
        self.textColor = UIColor.tintSecondary
        self.inactiveHintColor = UIColor.tintTertiary
        self.activeHintColor = UIColor.tintTertiary
        self.focusedBackgroundColor = .tertiary
        self.defaultBackgroundColor = .tertiary
        self.customBorderColor = UIColor.tintPrimary
        self.errorColor = UIColor.error
        self.customBorderWidth = 1.5
        self.customCornerRadius = 5
        self.layer.borderColor = self.focusedBackgroundColor.cgColor
        
    }
    
    func rightViewSetup(){
        crossButton.setImage( UIImage(named: "cross.icon"), for: .normal )
        crossButton.addTarget( self, action: #selector(crossAction), for: .touchUpInside )
        crossButton.frame = CGRect( x: -10, y: 0, width: buttonsImageWidth, height: self.frame.height )
        crossButton.imageView?.contentMode = .scaleAspectFit
        
        eyeButton.setImage(UIImage(named: "password.show.icon"), for: .normal )
        eyeButton.addTarget( self, action: #selector(eyeAction), for: .touchUpInside )
        eyeButton.imageView?.contentMode = .scaleAspectFit
        
        var viewArray = [UIView]()
        
        let rightView = UIView()
        
        viewArray.append(crossButton)
        rightView.frame = CGRect( x:0, y:0, width: (buttonsImageWidth) , height: self.frame.height)
        
        if self.isSecureTextEntry {
            viewArray.append(eyeButton)
            eyeButton.frame = CGRect( x: rightView.frame.width, y: 0, width: buttonsImageWidth, height: self.frame.height )
            rightView.frame = CGRect( x:0, y:0, width: (eyeButton.frame.width * CGFloat(viewArray.count)) + 5, height: self.frame.height )
        }
        viewArray.forEach { rightView.addSubview($0) }
        
        self.rightView = rightView
        self.rightViewMode = .always
    }
    
    @objc func crossAction(){
        self.text = ""
    }
    
    @objc func eyeAction(){
        self.isSecureTextEntry.toggle()
        self.eyeButton.setImage(isSecureTextEntry ? UIImage(named: "password.show.icon") : UIImage(named: "password.hide.icon"), for: .normal)
    }
    
}

class OneTimeCodeView: RTextField {
    
    let otpLabel = UILabel(frame: CGRect.zero)
    var countOfDigits = 6
    var didEnterLastDigit: ((String) -> Void)?
    var didTapToResendOTP: (() -> Void)?
    
    var countDownTimer : Timer?
    var count = 60
    
    func configure(countOfDigits: Int = 6) {
        self.countOfDigits = countOfDigits
        delegate = self
        keyboardType = .numberPad
        self.keyboardType = .asciiCapableNumberPad
        self.placeholder = "Enter the \(countOfDigits)-digit code"
        if #available(iOS 12.0, *) {
            textContentType = .oneTimeCode
        }
        otpLabel.text = " Get OTP code  "
        otpLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        otpLabel.sizeToFit()
        
        
        //        viewArray.append(otpLabel)
        otpLabel.frame = CGRect( x: rightView?.frame.width ?? 0, y: 0, width: otpLabel.frame.width, height: self.frame.height )
        self.rightView?.addSubview(otpLabel)
        rightView?.frame = CGRect( x:0, y:0, width: otpLabel.frame.width + (rightView?.frame.width ?? 0) + 5, height: self.frame.height )
        addTarget(self, action: #selector(textChanged), for: .editingChanged)
        
        //add action to resend
        otpLabel.addTapGesture {
            self.didTapToResendOTP?()
            self.startCountdown()
        }
    }
    
    @objc
    private func textChanged() {
        guard let text = self.text, text.count <= countOfDigits else { return }
        
        if text.count == countOfDigits {
            didEnterLastDigit?(text)
        }
    }
    
    deinit {
        countDownTimer?.invalidate()
        countDownTimer = nil
    }
    
    
    func startCountdown(){
        countDownTimer?.invalidate()
        self.otpLabel.isUserInteractionEnabled = false
        count = 60
        Timer.scheduledTimer(withTimeInterval: TimeInterval(count), repeats: false) {
            [weak self]timer in
            print(timer)
            self?.otpLabel.isUserInteractionEnabled = true
        }
        self.attributedTimer(count: count)
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        if(count > 0) {
            count -= 1
            self.attributedTimer(count: count)
            self.otpLabel.isUserInteractionEnabled = false
        } else{
            countDownTimer?.invalidate()
            self.otpLabel.text = "Resend"
            self.otpLabel.font = .boldSystemFont(ofSize: 17)
            self.otpLabel.textColor = .tintPrimary
            self.otpLabel.isUserInteractionEnabled = true
        }
    }
    
    func attributedTimer(count:Int) {
        let attributedString = NSMutableAttributedString(string: "Resend in\(count)sec", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 11),
            .foregroundColor: UIColor.tintPrimary.withAlphaComponent(0.85)
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor.tintSecondary, range: NSRange(location: 0, length: 9))
        otpLabel.attributedText = attributedString
    }
    
}

extension OneTimeCodeView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < countOfDigits || string == ""
    }
    
}
