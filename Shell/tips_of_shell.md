### 判断文件名后缀

```shell
file=”thisfile.txt”
echo “filename: ${file%.*}”
echo “extension: ${file##*.}”
输出：
filename: thisfile
extension: txt
```

### 判断文件名前缀

```shell
"$file" =~ ^arm64_	#判断文件带有 arm64_ 前缀
```

### 上一个函数的返回值

```shell
$?
```

### 找到 .o 后缀的文件, 并删除

```shell
find . -name "*.o" | xargs rm
```

> 有个疑问: 如果有很多文件名附有空格怎么删除, 比如 '__.SYMDEF SORTED' 这种类型的文件

### 处理文件名带空格的文件 (Internal Field Separator)

```shell
SAVEIFS=$IFS				#使用一个变量存储 IFS 的初始值
IFS=$(echo -en "\n\b")		#修改 IFS
...
IFS=$SAVEIFS				#还原 IFS
IFS=$(echo -en "\n\t")     #或者使用硬编码
```

Git 每个 commit 对应的 hash 值是该 commit 所有文件的 SHA-1 校验和(checksum)



# 判断退出状态:

```shell
cd ~/shell自动化示例
if [ $? -eq 0 ];then
    echo 'cd 成功'
else
	echo 'cd 失败'
fi
```

