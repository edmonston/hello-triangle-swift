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
            print("Error creating renderer: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        renderer?.mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
    }
}

