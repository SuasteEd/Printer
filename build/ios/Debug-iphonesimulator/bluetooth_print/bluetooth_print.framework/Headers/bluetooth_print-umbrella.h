#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BLEConnecter.h"
#import "BluetoothPrintPlugin.h"
#import "Connecter.h"
#import "ConnecterBlock.h"
#import "ConnecterManager.h"
#import "EscCommand.h"
#import "EthernetConnecter.h"
#import "TscCommand.h"

FOUNDATION_EXPORT double bluetooth_printVersionNumber;
FOUNDATION_EXPORT const unsigned char bluetooth_printVersionString[];

