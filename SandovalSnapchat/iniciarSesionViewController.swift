//
//  ViewController.swift
//  SandovalSnapchat
//
//  Created by Manuel Sandoval on 16/10/24.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var anonymousLoginButton: UIButton!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            print("Intentando Iniciar Sesion")
            if let error = error {
                print("Se presentó el siguiente error: \(error)")
            } else {
                print("Inicio de sesión exitoso")
            }
        }
    }

    @IBAction func anonymousLoginTapped(_ sender: Any) {
        signInAnonymously()
    }
    
    
    
    
    @IBAction func btnGmail(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("No se encontró el Client ID de Firebase.")
            return
        }
        // Crear la configuración para Google Sign-In
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        // Iniciar el flujo de inicio de sesión con Google
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            if let error = error {
                print("Error en la autenticación con Google: \(error.localizedDescription)")
                return
            }
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("No se pudo obtener el ID Token.")
                return
            }
            // Crear la credencial de Firebase con el ID Token de Google
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            // Autenticar con Firebase usando la credencial de Google
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error al autenticar con Firebase: \(error.localizedDescription)")
                } else {
                    print("¡Inicio de sesión exitoso con Google!")
                }
            }
        }
    }
    
    

    func signInAnonymously() {
        Auth.auth().signInAnonymously() { (authResult, error) in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                return
            }
            if let user = authResult?.user {
                print("Usuario autenticado con ID: \(user.uid)")
            }
        }
    }
}
