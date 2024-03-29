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
    /* ############################################################################################################################## */
    // MARK: -
    /* ############################################################################################################################## */
    struct ItemDisplayView: View {
        @State var itemImage: Image
        @State var size: CGSize
        
        var body: some View {
            return VStack(alignment: .center, spacing: 0) {
                self.itemImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top, 4)
                    .padding(.leading, 1)
                    .padding(.trailing, 1)
                    .padding(.bottom, self.size.height / 2)
                }
                .frame(width: self.size.width,
                       height: self.size.height,
                       alignment: .top)
                .offset(y: -self.size.height / 2.0)
        }
    }
    
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
     This class is used to represent one value of the spinner.
     
     It has only one required value: an icon, represented by a UIImage. It can be any size, but you shouldn't need anything bigger than about 100 display units square.
     */
    public struct DataItem: View {
        public static func == (lhs: RVS_SwiftUISpinner.DataItem, rhs: RVS_SwiftUISpinner.DataItem) -> Bool {
            return lhs.title == rhs.title && lhs.icon == rhs.icon
        }
        
        struct DataItemDisplay: View {
            @State var icon: Image
            @State var title: Text

            public static func == (lhs: RVS_SwiftUISpinner.DataItem.DataItemDisplay, rhs: RVS_SwiftUISpinner.DataItem.DataItemDisplay) -> Bool {
                return lhs.title == rhs.title && lhs.icon == rhs.icon
            }
            
            var body: some View {
                icon
            }
        }
        
        /** This is the required image to be displayed for the data item. This is what is most prominently displayed. */
        public let icon: Image
        /** This is the optional title for the data item. */
        public let title: String
        /** This is an optional description String, which can provide more detailed information about the data item. */
        public let description: String?
        /** This is an optional property, containing any associated data value. It needs to be cast. */
        public let value: Any?
        
        public var angle: Angle
        
        /* ################################################################## */
        /**
         The default initializer. The only required argument is the icon.
         
         - parameter icon: An image to be displayed for the value. This is the only required argument.
         - parameter inTitle: A String, with the title of this value. This is optional. Default is a blank String.
         - parameter description: An optional String (default is nil), with a description of the value.
         - parameter value: An optional value (default is nil) to be associated with this value item.
         */
        public init(angle inAngle: Angle, icon inIcon: Image, title inTitle: String = "", description inDescription: String? = nil, value inValue: Any? = nil) {
            angle = inAngle
            title = inTitle
            icon = inIcon
            description = inDescription
            value = inValue
        }
        
        var body: some View {
            DataItemDisplay(icon: icon, title: Text("TEST"))
        }
    }

    /* ################################################################## */
    // MARK: -
    /* ################################################################## */
    /**
     
     */
    @Binding var items: [DataItem]
    @State var selectedItem: Int = 0
    @State var openBackgroundColor: Color = Color.clear
    @State var controlBorderColor: Color = Color.red
    @State var controlBorderLineWidth: CGFloat = 2.0
    @State var itemBackgroundColor: Color = Color.yellow
    @State var itemBorderColor: Color = Color.clear
    @State var textColor: Color = Color.black
    @State var displayMode: DisplayMode = .both
    @State var displayModeThreshold: Int = 20
    @State var controlRotationAngleInRadians: Double = 0.0
    @State var rotationCompensation: Bool = true

    var body: some View {
        return GeometryReader { proxy in
            ZStack {
                Circle()
                    .fill(self.openBackgroundColor)
                
                Circle()
                    .stroke(
                        self.controlBorderColor,
                        style: StrokeStyle(
                            lineWidth: self.controlBorderLineWidth
                        )
                )
                
                ForEach(0..<self.items.count) { i in
                    ItemDisplayView(itemImage: self.items[i].icon,
                                                       size: CGSize(width: CGFloat.pi * min(proxy.size.width, proxy.size.height) / CGFloat(self.items.count) * 0.8,
                                                                    height: min(proxy.size.width, proxy.size.height) / 2.0)
                        )
                        .rotationEffect(.degrees((Double(i) / Double(self.items.count)) * 360.0),
                                        anchor: .center)
                        .position(CGPoint(x: min(proxy.size.width, proxy.size.height) / 2.0,
                                          y: min(proxy.size.width, proxy.size.height) / 2.0))
                }
            }
        }
    }
}
