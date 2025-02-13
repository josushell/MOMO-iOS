//
//  InputSecurityCodeViewController.swift
//  momoIOS
//
//  Created by 문다 on 2023/02/13.
//

import UIKit
import SnapKit

class InputSecurityCodeViewController: UIViewController {
    
    // MARK: - Properties
    
    // private let codeRegEx = "[A-Za-z0-9]{6,12}"
    
    private var isEditingCode: Bool {
        return self.codeField.isEditing
    }
    
    private lazy var titleLabel = CommonTitleLabel(labelText: "가입보안코드를\n등록해주세요.")
    
    private let codeField: UITextField = {
        let field = UITextField()
        field.font = UIFont.systemFont(ofSize: 40)
        field.textAlignment = .center
        return field
    }()
    
    private let borderView: UIView = {
        let border = UIView()
        border.backgroundColor = .black
        return border
    }()
    
    private lazy var okButton = CommonActionButton(buttonTitle: "확인")
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.codeField.delegate = self
        self.setupKeyboardNotifications()
        self.setupCustomNav()
        self.setupLayout()
        self.codeField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Selectors
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if self.isEditingCode {
            self.okButton.moveWithKeyboard(
                willShow: true,
                notification: notification,
                safeAreaBottomInset: self.view.safeAreaInsets.bottom
            )
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.okButton.moveWithKeyboard(
            willShow: false,
            notification: notification,
            safeAreaBottomInset: self.view.safeAreaInsets.bottom
        )
    }
    
    // MARK: - Helpers
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setupCustomNav() {
        let navBar = self.navigationController?.navigationBar
        navBar?.tintColor = .black
        navBar?.backIndicatorImage = UIImage(systemName: "arrow.left")
        navBar?.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")
        navBar?.topItem?.title = ""
    }
    
    private func setupLayout() {
        view.addSubviews(titleLabel, codeField, borderView, okButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(68)
            make.left.equalToSuperview().offset(24)
        }
        
        codeField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(90)
        }
        
        borderView.snp.makeConstraints { make in
            make.top.equalTo(codeField.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(0.75)
        }
        
        okButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(52)
        }
    }
}

extension InputSecurityCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let maxLength: Int = 12
            
        if text.count >= maxLength && range.length == 0 && range.location <= maxLength {
            return false
        }
        return true
    }
}
