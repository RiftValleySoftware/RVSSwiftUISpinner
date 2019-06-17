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
struct RVS_SwiftUISpinner: View {
    /* ################################################################## */
    /**
     */
    enum DisplayMode: Int {
        case radialOnly = -1
        case both = 0
        case pickerOnly = 1
    }

    /* ################################################################## */
    /**
     This struct is used to represent one value of the spinner.
     
     It has only one required value: an icon, represented by a UIImage. It can be any size, but you shouldn't need anything bigger than about 100 display units square.
     */
    public struct DataItem {
        /** This is the optional title for the data item. */
        public let title: String
        /** This is the required image to be displayed for the data item. This is what is most prominently displayed. */
        public let icon: UIImage
        /** This is an optional description String, which can provide more detailed information about the data item. */
        public let description: String?
        /** This is any associated data value. It is an optional "Any," and needs to be cast. */
        public let value: Any?
        
        /* ################################################################## */
        /**
         The default initializer. The only required argument is the icon.
         
         - parameter inTitle: A String, with the title of this value. This is optional. Default is a blank String.
         - parameter icon: An image to be displayed for the value. This is the only required argument.
         - parameter description: An optional String (default is nil), with a description of the value.
         - parameter value: An optional value (default is nil) to be associated with this value item.
         */
        public init(title inTitle: String = "", icon inIcon: UIImage, description inDescription: String? = nil, value inValue: Any? = nil) {
            title = inTitle
            icon = inIcon
            description = inDescription
            value = inValue
        }
    }

    /* ################################################################## */
    // MARK: -
    /* ################################################################## */
    /**
     
     */
    @State var items: [DataItem]
    @State var selectedItem: Int = 0
    @State var openBackgroundColor: Color = Color.clear
    @State var itemBackgroundColor: Color = Color.clear
    @State var controlBorderColor: Color = Color.red
    @State var controlBorderLineWidth: CGFloat = 1.0
    @State var itemBorderColor: Color = Color.clear
    @State var textColor: Color = Color.black
    @State var displayMode: DisplayMode = .both
    @State var displayModeThreshold: Int = 20
    @State var controlRotationAngleInRadians: Double = 0.0
    @State var rotationCompensation: Bool = true
    
    var body: some View {
        HStack {
            Circle()
                .stroke(
                    controlBorderColor,
                    style: StrokeStyle(
                        lineWidth: controlBorderLineWidth
                    )
                )
        }
    }
}

#if DEBUG
struct RVS_SwiftUISpinner_Previews: PreviewProvider {
    static var previews: some View {
        RVS_SwiftUISpinner(items: [], openBackgroundColor: Color.init(red: 1.0, green: 1.0, blue: 0.9, opacity: 1.0))
            .frame(width: 100, height: 100, alignment: .center)
    }
}
#endif
