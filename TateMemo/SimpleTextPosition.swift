import UIKit

class SimpleTextPosition: NSObject {
    let offset: Int
    
    init(offset: Int) {
        self.offset = offset
        super.init()
    }
    
    func compare(_ position: SimpleTextPosition, to other: SimpleTextPosition) -> ComparisonResult {
        if offset < other.offset {
            return .orderedAscending
        } else if offset > other.offset {
            return .orderedDescending
        } else {
            return .orderedSame
        }
    }
}
