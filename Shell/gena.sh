#!/bin/bash

# 这个脚本可以把当前文件夹下所有的 fat .a 全部合成为一个 fat .a。

# 查看文件夹下所有 .a 的 info


path=$(cd `dirname $0`;pwd) #进入当前文件夹

filelist=`ls $path`
for file in $filelist
do 
    if [ "${file##*.}"x = "a"x ]; then  #如果文件后缀为.a
        echo $file                      #打印文件
        lipo -info $path/$file          #查看 .a 信息
        if [ ! -a $path/$file ]; then
            lipo $file -thin armv7 -output armv7_$file      #把 .a 中的不同架构的库提取出来
            lipo $file -thin armv7s -output armv7s_$file
            lipo $file -thin i386 -output i386_$file
            lipo $file -thin x86_64 -output x86_64_$file
            lipo $file -thin arm64 -output arm64_$file
        fi
        
    fi
    
done

echo "已经生成不同架构的 .a"

mkdir armv7 armv7s arm64 i386 x86_64    #创建文件夹, 分别装不同架构的所有 .o 文件

# myFunc(){       # $1: file; $2: dir
#     mv $1 $2/$1
#     cd $2
#         ar -x $1
#         rm *.a
#     cd ..
# }

# for file in `ls $path`
# do
#     if [[ "$file" =~ ^arm64_ ]]; then   #判断文件带有 arm64_ 前缀
#         myFunc $file arm64
#     elif [[ "$file" =~ ^armv7_ ]]; then
#         myFunc $file armv7
#     elif [[ "$file" =~ ^armv7s_ ]]; then
#         myFunc $file armv7s
#     elif [[ "$file" =~ ^i386_ ]]; then
#         myFunc $file i386
#     elif [[ "$file" =~ ^x86_64_ ]]; then
#         myFunc $file arx86_64
#     fi
# done

for file in `ls $path`
do
    if [[ "$file" =~ ^arm64_ ]]; then   #判断文件带有 arm64_ 前缀
        mv $file arm64/$file
        cd arm64
            ar -x $file
            rm *.a
        cd ..
    elif [[ "$file" =~ ^armv7_ ]]; then
        mv $file armv7/$file
        cd armv7
            ar -x $file
            rm *.a
        cd ..
    elif [[ "$file" =~ ^armv7s_ ]]; then
        mv $file armv7s/$file
        cd armv7s
            ar -x $file
            rm *.a
        cd ..
    elif [[ "$file" =~ ^i386_ ]]; then
        mv $file i386/$file
        cd i386
            ar -x $file
            rm *.a
        cd ..
    elif [[ "$file" =~ ^x86_64_ ]]; then
        mv $file x86_64/$file
        cd x86_64
            ar -x $file
            rm *.a
        cd ..
    fi
done

echo "生成所有 .o 目标文件"

mkdir all_libs      #创建 all_libs 文件夹, 用于存放最后打包的 .a

echo "开始打包不同架构的 .a"

cd arm64
libtool -static -o lib123_arm64.a *.o -no_warning_for_no_symbols
cd ..
mv arm64/lib123_arm64.a all_libs/lib123_arm64.a

cd armv7
libtool -static -o lib123_armv7.a *.o -no_warning_for_no_symbols
cd ..
mv armv7/lib123_armv7.a all_libs/lib123_armv7.a

cd armv7s
libtool -static -o lib123_armv7s.a *.o -no_warning_for_no_symbols
cd ..
mv armv7s/lib123_armv7s.a all_libs/lib123_armv7s.a

cd i386
libtool -static -o lib123_i386.a *.o -no_warning_for_no_symbols
cd ..
mv i386/lib123_i386.a all_libs/lib123_i386.a

cd x86_64
libtool -static -o lib123_x86_64.a *.o -no_warning_for_no_symbols
cd ..
mv x86_64/lib123_x86_64.a all_libs/lib123_x86_64.a

rm -r x86_64 arm64 armv7 armv7s i386    #删除多余文件夹及其子文件

cd all_libs 
lipo -create lib123_arm64.a lib123_armv7.a lib123_armv7s.a lib123_i386.a lib123_x86_64.a -output MailCore_AllArchitect.a
cd ..

echo "静态库打包完成! 请到 all_libs 文件夹中查看!"