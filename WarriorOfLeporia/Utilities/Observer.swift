//
//  Observer.swift
//  WarriorOfLeporia
//
//  Created by Kirupa Nijastan on 4/4/18.
//  Copyright © 2018 Kirupa Nijastan. All rights reserved.
//

import Foundation
import SpriteKit

enum NotifyEvent {
    case SCORE
    case HURT
}

protocol Observer {
    func onNotify(event: NotifyEvent)
}
