import Cocoa

var nExtraReleases = 3

class Document: NSDocument {

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        self.addWindowController(windowController)
    }

    override func data(ofType typeName: String) throws -> Data {
        let someData = UnsafeRawPointer(bitPattern: 1)!
        return Data(bytes: someData, count: 0)
    }

    override func read(from data: Data, ofType typeName: String) throws {
    }

    deinit {
        Swift.print("Dealloc doc \(self)")
    }

    override func willPresentError(_ error: Error) -> Error {
        Swift.print("Presenting!")
        if (error._domain == NSCocoaErrorDomain) && (error._code == 67001) {
            Swift.print("Doing \(nExtraReleases) extra releases to \(self)")
            let unmanagedSelf = Unmanaged.passUnretained(self)
            for _ in 0..<nExtraReleases {
                unmanagedSelf.release()
            }
            nExtraReleases += 1
        }
        return super.willPresentError(error)
    }

}

