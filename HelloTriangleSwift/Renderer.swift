//
//  Renderer.swift
//  HelloTriangleSwift
//
//  Created by Peter Edmonston on 10/7/18.
//  Copyright © 2018 com.peteredmonston. All rights reserved.
//

import Metal
import MetalKit
import Foundation
import simd

class Renderer: NSObject {
    enum Errors: Error {
        case deviceNotFound, cantCreateLibrary, cantCreatePipeline, cantCreateQueue
    }

    let device: MTLDevice
    var pipelineState: MTLRenderPipelineState
    var commandQueue: MTLCommandQueue
    var viewportSize: simd_uint2 = vector2(0, 0)

    private let vertices: [Vertex] = {
        let vertex1 = Vertex(position: float2(-400,-400), color: float4([1, 0, 0, 1]))
        let vertex2 = Vertex(position: float2(0, 400), color: float4([0, 1, 0, 1]))
        let vertex3 = Vertex(position: float2(400, -400), color: float4([0, 0, 1, 1]))
        return [vertex1, vertex2, vertex3]
    }()

    init(metalKitView: MTKView) throws {
        guard let device = metalKitView.device else {
            throw Errors.deviceNotFound
        }
        guard let library = device.makeDefaultLibrary() else {
            throw Errors.cantCreateLibrary
        }
        guard let pipelineState = Renderer.makePipelineState(for: metalKitView, device: device, library: library) else {
            throw Errors.cantCreatePipeline
        }
        guard let commandQueue = device.makeCommandQueue() else {
            throw Errors.cantCreateQueue
        }

        self.device = device
        self.pipelineState = pipelineState
        self.commandQueue = commandQueue

        super.init()
    }

    static private func makePipelineState(for metalKitView: MTKView, device: MTLDevice, library: MTLLibrary) -> MTLRenderPipelineState? {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = library.makeFunction(name: "vertexShader")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentShader")
        descriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        descriptor.depthAttachmentPixelFormat = metalKitView.depthStencilPixelFormat
        return try? device.makeRenderPipelineState(descriptor: descriptor)
    }
}

extension Renderer: MTKViewDelegate {

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        viewportSize.x = UInt32(size.width)
        viewportSize.y = UInt32(size.height)
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
            let buffer = commandQueue.makeCommandBuffer(),
            let renderPassDescriptor = view.currentRenderPassDescriptor,
            let encoder = buffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        
        prepareToDraw(using: encoder)
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        finishDrawing(drawable, to: buffer, using: encoder)
    }

    private func prepareToDraw(using encoder: MTLRenderCommandEncoder) {
        let viewPort = MTLViewport(originX: 0, originY: 0,
                                   width: Double(viewportSize.x), height: Double(viewportSize.y),
                                   znear: -1.0, zfar: 1.0)
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBytes(vertices, length: MemoryLayout<Vertex>.stride * 3, index: Int(VertexInputIndexVertices.rawValue))
        encoder.setVertexBytes(&viewportSize, length: MemoryLayout<simd_uint2>.stride, index: Int(VertexInputIndexViewportSize.rawValue))
    }

    private func finishDrawing(_ drawable: MTLDrawable, to buffer: MTLCommandBuffer, using encoder: MTLRenderCommandEncoder) {
        encoder.endEncoding()
        buffer.present(drawable)
        buffer.commit()
    }
}
