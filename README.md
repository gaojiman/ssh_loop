# ssh_loop.sh
远程执行工具, 基于ssh, 可以批量在远端执行命令或者脚本.
但是有一个前提: 执行 ssh_loop 的机器必须可以直接登录目标机.

## 选取机器
也可以指定单个机器, 或者指定机器列表文件, 比如

    ./ssh_loop.sh -h server -e "date"

    ./ssh_loop.sh -h { $host_list_file } -e "date"  # 文件的第一列将作为执行的目标

## 定义命令
可以直接指定要执行的命令:

    ./ssh_loop.sh -h { $server } -e "date"

也可以指定一个脚本:

    ./ssh_loop.sh -h { $server } -e { $script_file }

脚本的第一行必须是"#!...", 比如"#!/bin/bash"

>> 脚本不止局限于sh哦!

<!--
可能你的脚本不是静态的，每次执行都有些变化，通过ssh_loop.sh执行的脚本还支持模版。

    ./ssh_loop.sh -h sd-im-fe01.bj -r "/path/to/script_file 1"

`/path/to/script_file 1`的执行结果应该是一个脚本，ssh_loop.sh将在sd-im-fe01.bj上执行这个脚本。

这里给出一个简单的模版脚本的例子：

    #!/bin/bash

    cat <<eof
    #!/bin/bash

    sleep $1
    eof

> 虽然模版和正常的脚本差别不大， 但是还是有差别，比如某些字符需要转意，像"`"

当然模版脚本的语言，或者生成的脚本的语言是没有限制的。
-->
