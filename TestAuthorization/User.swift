
//  Copyright © 2017 ArtSpell. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    dynamic var id = 0
    dynamic var username = ""
    dynamic var last_login = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
