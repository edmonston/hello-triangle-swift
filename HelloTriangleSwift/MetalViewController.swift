//
//  MetalViewController.swift
//  HelloTriangleSwift
//
//  Created by Peter Edmonston on 10/7/18.
//  Copyright © 2018 com.peteredmonston. All rights reserved.
//

import MetalKit
import UIKit

class MetalViewController: UIViewController {
    private var renderer: Renderer?

    @IBOutlet weak var metalView: MTKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metalView.device = MTLCreateSystemDefaultDevice()

        do {
            renderer = try Renderer(metalKitView: metalView)
            metalView.delegate = renderer
        } catch {
            showAlert(for: error)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        renderer?.mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
    }
    
    private func showAlert(for error: Error) {
        let message = """
                      Error creating renderer: \(error.localizedDescription). \
                      Make sure you are running on a real device.
                      """
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

