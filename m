Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab1BFLiK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 06:38:10 -0500
Received: from mail-pz0-f66.google.com ([209.85.210.66]:40183 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab1BFLiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 06:38:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=BB9Zqx7sXNW0i603ONbPh18dqqRZf4HUycgqzgOMnN4xSpZX6Tm0zJC8TwdonjQIwK
         rnYXA6+sm5v4n/nGPNQ20PY94uO3vr+iZPwnbVmyHvC4CUwWgHIibWm6suHe5tNGbGYP
         e7fwE49WQNdcSY/TJIP1IXeENvd7qywMDj7g8=
Date: Sun, 6 Feb 2011 19:37:49 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Subject: Re: Fwd: [PATCH]Translated
 linux-2.6/Documentation/SubmittingChecklist into Chinese
Message-ID: <20110206113747.GA2599@gmail.com>
Reply-To: gregkh@suse.de
Mail-Followup-To: linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org
References: <20110205045940.GB2531@gmail.com>
 <AANLkTinFAT5e+JxeCC1H=6=Kgy6tSZwo8URDJx8WdmBC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinFAT5e+JxeCC1H=6=Kgy6tSZwo8URDJx8WdmBC@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi us,
     The following patcher is given yesterday. I wonder if it is ok now.
     After other patchers mailed to greg and gregkh, LKML, i would get a mail from gregkh, which said patchers were ok. But I don't get a mail from them about this patcher.
     I think our maintainers should give every patcher a response that if it is ok or not on time. if it is not ok, maintainer should give some advice and come up with the mistakes in the patchers. Then we can correct them and keep on patching to kernel.
     Maybe What i said is unreliable, however we can discuss and then get 
a proper way to solve this problem.

Thanks.
Best Regards.
Harry Wei.

On Sun, Feb 06, 2011 at 06:03:14PM +0800, harryxiyou wrote:
> ---------- 已转发邮件 ----------
> 发件人： Harry Wei <harryxiyou@gmail.com>
> 日期： 2011年2月5日 下午12:59
> 主题： [PATCH]Translated linux-2.6/Documentation/SubmittingChecklist into
> Chinese
> 收件人： linux-kernel@vger.kernel.org
> 抄送： gregkh@suse.de
> 
> 
> Hi us,
>     I have translated linux-2.6/Documentation/SubmittingChecklist into
> Chinese. This patch can add translated file(SubmittingChecklist) under
> linux-2.6/Documentation/zh_CN/.
>     Thanks.
> 
>     Best Regards.
>     Harry Wei.
> 
> Signed-off-by: Harry Wei(harryxiyou@gmail.com)
> ---
>  Documentation/zh_CN/SubmitChecklist |  109
> +++++++++++++++++++++++++++++++++++
>  1 files changed, 109 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/zh_CN/SubmitChecklist
> 
> diff --git a/Documentation/zh_CN/SubmitChecklist
> b/Documentation/zh_CN/SubmitChecklist
> new file mode 100644
> index 0000000..1328483
> --- /dev/null
> +++ b/Documentation/zh_CN/SubmitChecklist
> @@ -0,0 +1,109 @@
> +Chinese translated version of Documentation/SubmitChecklist
> +
> +If you have any comment or update to the content, please contact the
> +original document maintainer directly.  However, if you have a problem
> +communicating in English you can also ask the Chinese maintainer for
> +help.  Contact the Chinese maintainer if this translation is outdated
> +or if there is a problem with the translation.
> +
> +Chinese maintainer: Harry Wei <harryxiyou@gmail.com>
> +---------------------------------------------------------------------
> +Documentation/SubmitChecklist 的中文翻译
> +
> +如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
> +交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
> +译存在问题，请联系中文版维护者。
> +
> +中文版维护者： 贾威威 Harry Wei <harryxiyou@gmail.com>
> +中文版翻译者： 贾威威 Harry Wei <harryxiyou@gmail.com>
> +中文版校译者： 贾威威 Harry Wei <harryxiyou@gmail.com>
> +
> +
> +以下为正文
> +---------------------------------------------------------------------
> +Linux内核提交清单
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +这里有一些内核开发者应该做的基本事情，如果他们想看到自己的内核补丁提交
> +被接受的更快。
> +
> +这些都是超出Documentation/SubmittingPatches文档里所提供的以及其他
> +关于提交Linux内核补丁的说明。
> +
> +1：如果你使用了一个功能那么就#include定义/声明那个功能的那个文件。
> +   不要依靠其他间接引入定义/声明那个功能的头文件。
> +
> +2：构建简洁适用或者更改CONFIG选项 =y，=m，或者=n。
> +   不要有编译警告/错误， 不要有链接警告/错误。
> +
> +2b：通过 allnoconfig, allmodconfig
> +
> +2c：当使用 0=builddir 成功地构建
> +
> +3：通过使用本地交叉编译工具或者其他一些构建产所，在多CPU框架上构建。
> +
> +4：ppc64 是一个很好的检查交叉编译的框架，因为它往往把‘unsigned long’
> +   当64位值来使用。
> +
> +5：按照Documentation/CodingStyle文件里的详细描述，检查你补丁的整体风格。
> +   使用补丁风格检查琐碎的违规(scripts/checkpatch.pl)，审核员优先提交。
> +   你应该调整遗留在你补丁中的所有违规。
> +
> +6：任何更新或者改动CONFIG选项都不能打乱配置菜单。
> +
> +7：所有的Kconfig选项更新都要有说明文字。
> +
> +8：已经认真地总结了相关的Kconfig组合。这是很难通过测试做好的--脑力在这里下降。
> +
> +9：检查具有简洁性。
> +
> +10：使用'make checkstack'和'make namespacecheck'检查，然后修改所找到的问题。
> +    注意：堆栈检查不会明确地出现问题，但是任何的一个函数在堆栈上使用多于512字节
> +    都要准备修改。
> +
> +11：包含kernel-doc到全局内核APIs文件。（不要求静态的函数，但是包含也无所谓。）
> +    使用'make htmldocs'或者'make mandocs'来检查kernel-doc，然后修改任何
> +    发现的问题。
> +
> +12：已经通过CONFIG_PREEMPT, CONFIG_DEBUG_PREEMPT,
> +    CONFIG_DEBUG_SLAB, CONFIG_DEBUG_PAGEALLOC, CONFIG_DEBUG_MUTEXES,
> +    CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_SPINLOCK_SLEEP测试，并且同时都
> +    使能。
> +
> +13：已经都构建并且使用或者不使用 CONFIG_SMP 和 CONFIG_PREEMPT测试执行时间。
> +
> +14：如果补丁影响IO/Disk，等等：已经通过使用或者不使用 CONFIG_LBDAF 测试。
> +
> +15：所有的codepaths已经行使所有lockdep启用功能。
> +
> +16：所有的/proc记录更新都要作成文件放在Documentation/目录下。
> +
> +17：所有的内核启动参数更新都被记录到Documentation/kernel-parameters.txt文件中。
> +
> +18：所有的模块参数更新都用MODULE_PARM_DESC()记录。
> +
> +19：所有的用户空间接口更新都被记录到Documentation/ABI/。查看Documentation/ABI/README
> +    可以获得更多的信息。改变用户空间接口的补丁应该被邮件抄送给linux-api@vger.kernel.org。
> +
> +20：检查它是不是都通过`make headers_check'。
> +
> +21：已经通过至少引入slab和page-allocation失败检查。查看Documentation/fault-injection/。
> +
> +22：新加入的源码已经通过`gcc -W'（使用"make EXTRA_CFLAGS=-W"）编译。这样将产生很多烦恼，
> +    但是对于寻找漏洞很有益处，例如:"warning: comparison between signed and unsigned"。
> +
> +23：当它被合并到-mm补丁集后再测试，用来确定它是否还和补丁队列中的其他补丁一起工作以及在VM，VFS
> +    和其他子系统中各个变化。
> +
> +24：所有的内存屏障{e.g., barrier(), rmb(), wmb()}需要在源代码中的一个注释来解释他们都是干什么的
> +    以及原因。
> +
> +25：如果有任何输入输出控制的补丁被添加，也要更新Documentation/ioctl/ioctl-number.txt。
> +
> +26：如果你的更改代码依靠或者使用任何的内核APIs或者与下面的kconfig符号有关系的功能，你就要
> +    使用相关的kconfig符号关闭， and/or =m（如果选项提供）[在同一时间不是所用的都启用，仅仅各个或者自由
> +    组合他们]：
> +
> +    CONFIG_SMP, CONFIG_SYSFS, CONFIG_PROC_FS, CONFIG_INPUT, CONFIG_PCI,
> +    CONFIG_BLOCK, CONFIG_PM, CONFIG_HOTPLUG, CONFIG_MAGIC_SYSRQ,
> +    CONFIG_NET, CONFIG_INET=n (后一个使用 CONFIG_NET=y)
> --
> 1.7.0.4
> 
> 
> 
> 
> 
> 
> 
> -- 
> Best Regards.
> Harry Wei.
> Do what u like!
