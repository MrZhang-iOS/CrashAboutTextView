# CrashAboutTextView
你永远也想不到UITextView的崩溃居然跟NSMutableArray有关系！

# **Demo说明**
	你永远也想不到UITextView的崩溃和NSMutableArray有关系！

UITextView控件就是用来显示文字，无论文字内容长短或者何种字体，都不应该造成崩溃。

### 捕捉的异常信息如下：

````
出错堆栈
0	CoreText
TBaseFont::GetDefaultComposite(UIFontFlag, unsigned long) const + 192
1	CoreText
TBaseFont::GetDefaultComposite(UIFontFlag, unsigned long) const + 192
2	CoreText
TBaseFont::ShouldSkipCascadeList(FontFallbackStage, __CFArray const*, UIFontFlag, unsigned long, unsigned short const*, long) const + 96
3	CoreText
TBaseFont::CreateDescriptorForCharacters(__CFArray const*, UIFontFlag, unsigned long, CTFontFallbackMode, unsigned short const*, long, unsigned int&, long&) const + 164
4	CoreText
TFont::InitDescriptor(unsigned short const*, long, __CFString const*, unsigned long, CTFontFallbackMode, unsigned int&, long&) const + 212
5	CoreText
TFont::TFont(TFont const&, unsigned short const*, long, __CFString const*, unsigned long, CTFontFallbackMode, long&) + 72
6	CoreText
TCFRef<CTFont*> TCFBase_NEW<CTFont, TFont const&, unsigned short const*&, long&, __CFString const*&, unsigned long&, CTFontFallbackMode&, long&>(TFont const&&&, unsigned short const*&&&, long&&&, __CFString const*&&&, unsigned long&&&, CTFontFallbackMode&&&, long&&&) + 136
7	CoreText
_CTFontCreateForCharactersWithLanguageAndOption + 100
8	UIFoundation
-[UIFont(UIFont_AttributedStringDrawing) bestMatchingFontForCharacters:length:attributes:actualCoveredLength:] + 112
9	UIFoundation
-[NSMutableAttributedString(NSMutableAttributedStringKitAdditions) fixFontAttributeInRange:] + 6780
10	UIFoundation
-[NSMutableAttributedString(NSMutableAttributedStringKitAdditions) fixAttributesInRange:] + 124
11	UIFoundation
-[NSTextStorage processEditing] + 220
12	UIFoundation
-[NSTextStorage endEditing] + 96
13	UIFoundation
-[NSTextStorage coordinateEditing:] + 76
14	UIKitCore
-[UITextView setAttributedText:] + 272
15	UIKitCore
-[UITextView setText:] + 132
````

### 虽然Crash的代码发生在UITextView的setText:接口处，造成Crash的原因其实是在NSArray+Swizzle模块对系统可变数组__NSArrayM的【- objectAtIndex:】接口进行方法hook时，获取索引值后进行了NSNull判断。
> 注释掉NSArray+Swizzle.m文件第107~110行代码即不再Crash。
> 如下：

````
- (id)zw_mutableObjectAtIndex:(NSUInteger)index {
    id obj = nil;
    if (index >= 0 && index < self.count) {
        obj = [self zw_mutableObjectAtIndex:index];
//        if (obj && [obj isKindOfClass:[NSNull class]])
//        {
//            obj = nil;
//        }
    } else {
        NSLog(@"exception: mutable array out of bounds");
    }
    return obj;
}
````

> 分析原因是系统Foundation和CoreText在setText:时最终有调用__NSArrayM的【- objectAtIndex:】接口，且数据存在对NSNull对象的操作，具体原因还请技术大牛科普源码。


