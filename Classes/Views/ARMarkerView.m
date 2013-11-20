//
//  ARMarkerView.m
//  ChattAR for Facebook
//
//  Created by QuickBlox developers on 3/26/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "ARMarkerView.h"
#import "ChatRoomStorage.h"

#define markerWidth 114
#define markerHeight 40

@implementation ARMarkerView

@synthesize target;
@synthesize action;
@synthesize userStatus, userPhotoView, userName;
@synthesize distance;

- (id)initWithGeoPoint:(QBCOCustomObject *)room {
    	
	CGRect theFrame = CGRectMake(0, 0, markerWidth, markerHeight);
	
	if ((self = [super initWithFrame:theFrame])) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        // save user annotation
        self.currentRoom = room;
        
        [self setUserInteractionEnabled:YES];
        
        // bg view for user name & status & photo
        //
        UIImageView *container = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, markerWidth, markerHeight)];
		[container.layer setBorderColor:[[UIColor whiteColor] CGColor]];
		[container.layer setBorderWidth:1.0];
        [container setImage:[UIImage imageNamed:@"Marker2.png"]];
        container.layer.cornerRadius = 2;
        container.clipsToBounds = YES;
        [container setBackgroundColor:[UIColor clearColor]];
        [self addSubview:container];
        [container release];
        
        
        // add Room Picture
		userPhotoView = [[AsyncImageView alloc] initWithFrame: CGRectMake(0, 0, 40, 40)];
        userPhotoView.image = [UIImage imageNamed:@"room.jpg"];
		[container addSubview: userPhotoView];
        [userPhotoView release];
        
        // add userName
        userName = [[UILabel alloc] initWithFrame:CGRectMake(42, 0, container.frame.size.width-43, container.frame.size.height/2)];
        [userName setBackgroundColor:[UIColor clearColor]];
        [userName setText:[room.fields objectForKey:kName]];
        [userName setFont:[UIFont boldSystemFontOfSize:11]];
        [userName setTextColor:[UIColor whiteColor]];
        [container addSubview:userName];
        [userName release];
        
        // add userStatus
        userStatus = [[UILabel alloc] initWithFrame:CGRectMake(42, 20, container.frame.size.width-43, container.frame.size.height/2)];
        [userStatus setFont:[UIFont systemFontOfSize:11]];
        [userStatus setBackgroundColor:[UIColor clearColor]];
        [userStatus setTextColor:[UIColor whiteColor]];
        [container addSubview:userStatus];
        [userStatus release];
	}
	
    return self;
}

- (CLLocationDistance) updateDistance:(CLLocation *)newOriginLocation {
    CLLocation *pointLocation = [[CLLocation alloc] initWithLatitude:[[_currentRoom.fields objectForKey:kLatitude] doubleValue] longitude:[[_currentRoom.fields objectForKey:kLongitude] doubleValue]];
    //NSLog(@"Loc: %f %f", newOriginLocation.coordinate.latitude, newOriginLocation.coordinate.longitude);
    CLLocationDistance _distance = [pointLocation distanceFromLocation:newOriginLocation];
    [pointLocation release];
    
    if(_distance < 0){
        [userStatus setHidden:YES];
    }else{
        if (_distance > 1000){
            userStatus.text = [NSString stringWithFormat:@"%.000f km", _distance/1000];
        }else {
            userStatus.text = [NSString stringWithFormat:@"%.000f m", _distance];
        }
        
        [userStatus setHidden:NO];
    }
    
    distance = _distance;
    
    return _distance;
}

- (double)distanceFrom:(CLLocationCoordinate2D)locationA to:(CLLocationCoordinate2D)locationB {
    double R = 6368500.0; // in meters
    
    double lat1 = locationA.latitude*M_PI/180.0;
    double lon1 = locationA.longitude*M_PI/180.0;
    double lat2 = locationB.latitude*M_PI/180.0;
    double lon2 = locationB.longitude*M_PI/180.0;
    
    return acos(sin(lat1) * sin(lat2) + 
                cos(lat1) * cos(lat2) *
                cos(lon2 - lon1)) * R;
}


//// touch action
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    if([target respondsToSelector:action]){
//        [target performSelector:action withObject:self];
//    }
//}


- (NSString *)description {
    return [NSString stringWithFormat:@"distance=%d", distance];
}

@end
