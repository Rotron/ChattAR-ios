//
//  QBRAverageAnswer.h
//  Quickblox
//
//  Created by Alexander Chaika on 05.04.12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBRAverageAnswer : QBRatingsServiceAnswer {
@protected
	QBRAverage *averageData;
}

@property (nonatomic, readonly) QBRAverage *averageData;

@end
