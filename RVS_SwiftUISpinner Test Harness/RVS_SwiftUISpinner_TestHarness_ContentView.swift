/**
 © Copyright 2019, The Great Rift Valley Software Company
 
 LICENSE:
 
 MIT License
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
 modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 
 The Great Rift Valley Software Company: https://riftvalleysoftware.com
 */

import SwiftUI

/* ################################################################################################################################## */
// MARK: -
/* ################################################################################################################################## */
/* ################################################################## */
/**
 Read all the images from the bundle, segregated by directory.
 */
func RVS_SwiftUISpinner_Test_Harness_ReadImages() -> [RVS_SwiftUISpinner_Test_Harness_DirElement] {
    var ret: [RVS_SwiftUISpinner_Test_Harness_DirElement] = []
    
    if let resourcePath = Bundle.main.resourcePath {
        let rootPath =  "\(resourcePath)/DisplayImages"

        // What we do here, is load in the image directories, and assign each one to a switch segment.
        do {
            var temp: [RVS_SwiftUISpinner_Test_Harness_DirElement] = []
            
            let dirPaths = try FileManager.default.contentsOfDirectory(atPath: rootPath).sorted()
            
            dirPaths.forEach {
                let path = rootPath + "/" + $0
                let name = String($0[$0.index($0.startIndex, offsetBy: 3)...])  // Strip off the number in front (used to sort).
                temp.append(RVS_SwiftUISpinner_Test_Harness_DirElement(name: name, path: path, items: []))
            }
            
            ret = temp.sorted()
            
            for i in ret.enumerated() {
                let imagePaths = try FileManager.default.contentsOfDirectory(atPath: i.element.path).sorted()
                
                imagePaths.forEach {
                    if let imageFile = FileManager.default.contents(atPath: "\(i.element.path)/\($0)"), let image = UIImage(data: imageFile) {
                        // The name is the filename, minus the file extension, and minus the numbers in front.
                        let imageName = String($0.prefix($0.count - 4)[$0.index($0.startIndex, offsetBy: 3)...])    // Strip off the sorting number (front), and the file extension.
                        let item = RVS_SwiftUISpinner.DataItem(angle: .degrees(0), icon: Image(uiImage: image), title: imageName)
                        ret[i.offset].items.append(item)
                    }
                }
            }
            // At this point, our _directories property is populated with our special directory type; each, containing an array of image objects.
        } catch let error {
            print(error)
        }
    }
    
    return ret
}

/* ###################################################################################################################################### */
// MARK: - The Directory List Container Struct
/* ###################################################################################################################################### */
/**
 This is a custom struct that holds a list of image/text objects (spinner value elements).
 */
struct RVS_SwiftUISpinner_Test_Harness_DirElement: Comparable, Equatable {
    /* ################################################################## */
    /**
     */
    static func < (lhs: RVS_SwiftUISpinner_Test_Harness_DirElement, rhs: RVS_SwiftUISpinner_Test_Harness_DirElement) -> Bool {
        return lhs.path < rhs.path
    }
    
    /* ################################################################## */
    /**
     */
    static func == (lhs: RVS_SwiftUISpinner_Test_Harness_DirElement, rhs: RVS_SwiftUISpinner_Test_Harness_DirElement) -> Bool {
        return lhs.path == rhs.path
    }
    
    var name: String = ""
    var path: String = ""
    var items: [RVS_SwiftUISpinner.DataItem] = []
}

/* ###################################################################################################################################### */
// MARK: -
/* ###################################################################################################################################### */
/**
 */
struct RVS_SwiftUISpinner_Test_Harness_ContentView: View {
    /* ################################################################################################################################## */
    // MARK: -
    /* ################################################################################################################################## */
    var directories: [RVS_SwiftUISpinner_Test_Harness_DirElement]
    @State var selectedDirectory: Int = 2 {
        didSet {
            selectedItems = self.directories[self.selectedDirectory].items
        }
    }
    @State var selectedItems: [RVS_SwiftUISpinner.DataItem] = []
    
    var openBackgroundColor: Color = Color.init(red: 1.0,
                                                green: 1.0,
                                                blue: 0.9,
                                                opacity: 1.0
                                                )
    
    var body: some View {
        if selectedItems.isEmpty {
            selectedItems = self.directories[self.selectedDirectory].items
        }
        
        return GeometryReader { geometry in
            VStack {
                HStack {
                    Spacer()
                    RVS_SwiftUISpinner(items: self.$selectedItems,
                                       openBackgroundColor: self.openBackgroundColor
                        )
                        .frame(width: min(geometry.size.width - 20, geometry.size.height - 20),
                               height: min(geometry.size.width - 20, geometry.size.height - 20),
                               alignment: .center
                    )
                    Spacer()
                }
                Spacer()
                SegmentedControl(selection: self.$selectedDirectory) {
                    ForEach(0..<self.directories.count) { index in
                        Text(self.directories[index].name).tag(index)
                    }
                }
                .padding()
            }
            .padding(.top, 10)
        }
        .background(Image("background-gradient")
                        .resizable()
                    )
    }
}

/* ###################################################################################################################################### */
// MARK: -
/* ###################################################################################################################################### */
/**
 */
#if DEBUG
struct RVS_SwiftUISpinner_Test_Harness_ContentView_Previews: PreviewProvider {
    @State var selectedDir: Int = 2
    static var previews: some View {
        RVS_SwiftUISpinner_Test_Harness_ContentView(directories: RVS_SwiftUISpinner_Test_Harness_ReadImages())
    }
}
#endif
