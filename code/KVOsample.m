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

    [p1 setHitPoint: 800]; // --------------------------------- (1)
    /* 键路径的值被改变了，发送通知给观察者 */

    [p1 sufferDamage: 200];// --------------------------------- (2)
    /* 不符合 kvc 准则，则不会触发 KVO 的通知 */

    dra.master = p2;       // --------------------------------- (3)
    /* 这个情况是这样子的
          首先 p2 的结构和 master 是一致的，所以我们变换master之后，路径还是没有更改的，只是
          路径对应的实例发生了改变，master的实例发生了改变，hitPoint实例也发生了改变，结果就是
          master.hitPoint 发生了改变。就会调用啦。

          master 是 属性,所以在设置的时候机会调用到get方法，符合kvc的准则。
          然后 对应的链也会递归的调用设置好。

          实际上就是在这条路径上的任何一个属性发上改变了，都会触发通知。只要又一个发生，就会递归的影响到
          叶子路径的内容。
    */

    p1.hitPoint -= 100;    // --------------------------------- (4)
    /* 因为 hitPoint 是属性， 所以这样的实际效果就是 调用 setHitPoint: 的方法
       主要是因为，设置 @property 之后，并且 @synthesize 之后。就会自动生成
       set 方法和 get 方法，所以是符合 KVC 准则的。
    */

    p2.hitPoint += 200;    // --------------------------------- (5)
    [dra removeObserver:dra forKeyPath:@"master.hitPoint"]; //- (6)
    p2.hitPoint -= 300;    // --------------------------------- (7)

    [p1 removeObserver:p2 forKeyPath:@"hitPoint"];
  }

  return 0;
}
