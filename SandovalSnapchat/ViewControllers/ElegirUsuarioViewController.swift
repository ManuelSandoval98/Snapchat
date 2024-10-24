//
//  ElegirUsuarioViewController.swift
//  SandovalSnapchat
//
//  Created by Manuel Sandoval on 23/10/24.
//

import UIKit
import Firebase

class ElegirUsuarioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var listaUsuarios: UITableView!
    
    var usuarios: [Usuario] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listaUsuarios.delegate = self
        listaUsuarios.dataSource = self
        
        Database.database().reference().child("usuarios").observe(DataEventType.childAdded, with: { snapshot in
            print(snapshot)
            
            if let usuarioDict = snapshot.value as? [String: Any],
               let email = usuarioDict["email"] as? String {
                let usuario = Usuario()
                usuario.email = email
                usuario.uid = snapshot.key
                
                self.usuarios.append(usuario)
                self.listaUsuarios.reloadData()
            } else {
                print("Error: Invalid data format.")
            }
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let usuario = usuarios[indexPath.row]
        cell.textLabel?.text = usuario.email
        return cell
    }
}
