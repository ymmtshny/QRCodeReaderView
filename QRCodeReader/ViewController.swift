import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, QRCodeDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _QRCodeReaderView = QRCodeReaderView(frame:CGRect(x:self.view.frame.size.width/4,
                                                              y:100,
                                                              width:self.view.frame.size.width/2,
                                                              height:self.view.frame.size.width/2),
                                                 delegate:self)
        self.view.addSubview(_QRCodeReaderView)
    }
    
    internal func didReadQRCode(code: String) {
        let alert = UIAlertController.singleBtnAlertWithTitle("成功", message: "\(code)", action: {})
        self.present(alert, animated: true, completion: {})
    }
}

protocol QRCodeDelegate : class {
    func didReadQRCode(code: String)
}

class QRCodeReaderView : UIView, AVCaptureMetadataOutputObjectsDelegate {

    weak var delegate: QRCodeDelegate?
    var videoCaptureDevice: AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    var device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    var output = AVCaptureMetadataOutput()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var captureSession = AVCaptureSession()
    var code: String?
    
    convenience init(frame:CGRect, delegate:Any) {
        self.init(frame: frame)
        if let delegate = delegate as? QRCodeDelegate {
            self.delegate = delegate
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.setupCamera()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupCamera()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if (captureSession.isRunning == false) {
            captureSession.startRunning()
        }
        self.backgroundColor = .clear
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        if (captureSession.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    
    private func setupCamera() {
        
        let input = try? AVCaptureDeviceInput(device: videoCaptureDevice)
        
        if self.captureSession.canAddInput(input) {
            self.captureSession.addInput(input)
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        if let videoPreviewLayer = self.previewLayer {
            videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer.frame = self.bounds
            self.layer.addSublayer(videoPreviewLayer)
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if self.captureSession.canAddOutput(metadataOutput) {
            self.captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code]
        } else {
            print("Could not add metadata output")
        }
    }
    
    internal func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // This is the delegate'smethod that is called when a code is readed
        for metadata in metadataObjects {
            let readableObject = metadata as! AVMetadataMachineReadableCodeObject
            let code = readableObject.stringValue
            self.delegate?.didReadQRCode(code: code!)
            print(code!)
        }
    }

}
