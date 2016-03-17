#import <Foundation/Foundation.h>

@interface Creature: NSObject // use ARC
{
  NSString *name;
  int hitPoint; // hit point.
}
- (id)initWithName:(NSString *)str hitPoint:(int)n;
@property int hitPoint;
- (void)sufferDamage:(int)val;
- (NSString *)description;
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context;
@end

@implementation Creature
- (id)initWithName:(NSString *)str hitPoint:(int)n {
  if ((self = [super init]) != nil)
    name = str, hitPoint = n;
    return self;
}
@synthesize hitPoint;

- (void)sufferDamage:(int)val {
  hitPoint = (hitPoint > val) ? (hitPoint - val) : 0;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<<%@, %@, HP=%d>>",
            NSStringFromClass([self class]), name, hitPoint];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{ // receive the notification of KVO
  printf("%s", [[NSString stringWithFormat:@"--- Received by %@ ---\n"
                                           @"Object=%@, Path=%@\n"
                                           @"Change=%@\n", self, object, keyPath, change] UTF8String]);
}

@end

@interface Person: Creature
@end

@implementation Person
@end

@interface Dragon:Creature
@property (weak) Person *master;
@end

@implementation Dragon
@synthesize master;
@end

int main(void)
{
  int opt = NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew;

  @autoreleasepool {
    Person *p1, *p2;
    Dragon *dra;

    p1 = [[Person alloc] initWithName:@"Taro" hitPoint:500];
    p2 = [[Person alloc] initWithName:@"Jiro" hitPoint:140];
    dra = [[Dragon alloc] initWithName:@"Choco" hitPoint:400];

    dra.master = p1;

    [dra addObserver:dra forKeyPath:@"master.hitPoint"
          options:opt context:NULL]; // ----------------------- (A)

    [p1 addObserver:p2 forKeyPath:@"hitPoint"
          options:opt context:NULL]; // ----------------------- (B)

    [p1 sufferDamage: 200];// --------------------------------- (2)
    /* 不符合 kvc 准则，则不会触发 KVO 的通知 */

    [dra removeObserver:dra forKeyPath:@"master.hitPoint"]; //- (6)
    [p1 removeObserver:p2 forKeyPath:@"hitPoint"];
  }

  return 0;
}
