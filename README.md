# make-booklet
Information and tools for making booklet with pdfbook command

在原书pdf文件所在目录打开vim，先手工输入

```
pdfbook -- '<已经混入辅助文件的pdf文件名>'
```

然后保证光标在这一行上，执行

```
:PDFBookStart 10 4
```

其中10是这一叠的纸张数，4是pdf中封面页的页码。当前行就会变为

```
pdfbook -- '<文件名>' "4,1,1,1,1,1,4-37"
```

再在这一行上执行命令

```
:PDFBookNext 10
```

当前行后面就会插入一个新行

```
pdfbook -- '<文件名>' "38-77"
```

注意新行是根据前一行的页码推出来的，所以每次执行命令时需要保证光标在最后一行上。

如果你需要每册有多个内部叠，可以继续执行: `PDFBookNext` ，也可以按需改变这一叠所包含的纸张数（如前所述，建议取8到10）。

要生成当前册的最后一叠，则执行

```
:PDFBookEnd 10 2
```

其中10是这一叠的纸张数，2是笔记页的纸张数（注意是纸张数，一张纸两页，所以这里会加入4页笔记页）。

这个命令会创建当前册最后一叠的命令，以及用同样的每叠纸张数创建下一册第一叠的命令，以空行分隔。如果你要修改下一册第一叠的纸张数，可以把新创建的下一册第一叠删掉，把光标移到当前册的任意位置（段落内部即可），执行

```
:PDFBookNextBook 8
```

就会创建包含8张纸的下一册第一叠的命令。

整本书的最后一叠，用下面命令创建

```
:PDFBookFinal 10 327 2
```

其中10照旧是纸张数，327是全书最后一页的页码，2是最少保留的笔记页数。注意这里有坑，这一叠用书中的内容（到327页为止）很可能不能凑够指定的纸张数（10张），这时就会用笔记页补够。当然这样一来笔记页就可能很多，如果你不想出现这种情况，就需要考虑把前面几叠的纸张匀过来。当然我这里没有做自动回溯求最优解，你可以人手把前面的一些命令删掉，用其他参数（比如改成每叠8张纸）重新创建试试。熟练后一般试个两三次就差不多了。

如果按照指定的纸张数和保留笔记页数，这一叠无法到达全书最后一页，命令就会报错。你需要先用 `:PDFBookNext` 创建一个内部叠再来调用 `:PDFBookFinal`

以上方案在vim里生成好之后，执行

```
:%!bash
```

就可以在vim里直接执行这些指令，创建出多个booklet版的pdf文件。

然后逐个文件检查一下，主要是看看页数对不对（注意由于是双面打印，pdf的页数是纸张数的两倍），有没有多余的空白页。检查好后打印即可，记得选择双面打印。
