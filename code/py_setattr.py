class test(object):

    def __init__(self):
        self.__attr1 = 'test1'
        self.__attr2 = 'test2'
        self.attr3 = 'test3'

# start

# create instance of class test.
T = test()

# check attribute attr4
print 'attr4 exists? '
# print T.attr4

# start create new attribute attr4
setattr(T, 'attr4', 'test4')
print 'create new attribute <attr4> ' + T.attr4

# start to change the value of attr3
print 'attribute <attr3>:' + T.attr3
setattr(T, 'attr3', 'test3_changed')
print 'changed attribute <attr3> :' + T.attr3
