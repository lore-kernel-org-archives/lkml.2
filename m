Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab1GPJ1M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 05:27:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64596 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752658Ab1GPJ1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 05:27:10 -0400
Message-ID: <4E21595D.2040309@cn.fujitsu.com>
Date: Sat, 16 Jul 2011 17:26:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: jiaweiwei.xiyou@gmail.com
CC: greg@kroah.com, linux-kernel@vger.kernel.org, kongjianjun@gmail.com,
        joe@perches.com, rdunlap@xenotime.net, harryxiyou@gamil.com
Subject: Re: [Patch Resend]Fix the messy code file Documentation/zh_CN/SubmitChecklist
References: <20110716074255.GA4150@gmail.com> <20110716083618.GA4941@gmail.com>
In-Reply-To: <20110716083618.GA4941@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-16 17:26:20,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-16 17:26:20
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

16:36, Harry Wei wrote:
> From: Harry Wei <harryxiyou@gmail.com>
> 
> So sorry with a mistake, which i did not check my patch with
> ./checkpatch.pl. This one is all well for checkpatch.pl. It 
> can fix the messy code file Documentation/zh_CN/SubmitChecklist correctly.
> 

I'm not fond of kernel documentation translation.. but after a quick
look, I don't think the quality of this translation is satisfying..

I'm not going to review the whole doc, just a few comments below.

> Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> ---
>  Documentation/zh_CN/SubmitChecklist |  118 +++++++++++++++++-----------------
>  1 files changed, 59 insertions(+), 59 deletions(-)
> 
> diff --git a/Documentation/zh_CN/SubmitChecklist b/Documentation/zh_CN/SubmitChecklist
> index 951415b..7f41713 100644
> --- a/Documentation/zh_CN/SubmitChecklist
> +++ b/Documentation/zh_CN/SubmitChecklist
> @@ -8,102 +8,102 @@ or if there is a problem with the translation.
>  
>  Chinese maintainer: Harry Wei <harryxiyou@gmail.com>
>  ---------------------------------------------------------------------
> -Documentation/SubmitChecklist ?????ķ???
> +Documentation/SubmitChecklist 的中文翻译
>  
> -?????????ۻ????±??ĵ????ݣ???ֱ??�ϵԭ?ĵ???ά???ߡ???????ʹ??Ӣ??
> -??????�?ѵĻ???Ҳ?????????İ?ά?????????????�?????²???ʱ???߷?
> -?????????⣬??�ϵ???İ?ά???ߡ?
> +如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
> +交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
> +译存在问题，请联系中文版维护者。
>  
> -???İ?ά???ߣ? ?????? Harry Wei <harryxiyou@gmail.com>
> -???İ淭???ߣ? ?????? Harry Wei <harryxiyou@gmail.com>
> -???İ?У???ߣ? ?????? Harry Wei <harryxiyou@gmail.com>
> +中文版维护者： 贾威威 Harry Wei <harryxiyou@gmail.com>
> +中文版翻译者： 贾威威 Harry Wei <harryxiyou@gmail.com>
> +中文版校译者： 贾威威 Harry Wei <harryxiyou@gmail.com>

I don't think you can be the reviewer as well as the translator.

>  
>  
> -????Ϊ????
> +以下为正文
>  ---------------------------------------------------------------------
> -Linux?ں??ύ?嵥
> +Linux内核提交清单
>  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>  
> -??????һЩ?ں˿?????Ӧ?????Ļ??????飬?????????뿴???Լ????ں˲????ύ
> -?????ܵĸ??졣
> +这里有一些内核开发者应该做的基本事情，如果他们想看到自己的内核补丁提交
> +被接受的更快。

You're a bit rigid in translation. I believe this should be better:

如果他们想看到自己提交的内核补丁被接受的更快。

[snip]

>  
> -15?????е?codepaths?Ѿ???ʹ????lockdep???ù??ܡ?
> +15：所有的codepaths已经行使所有lockdep启用功能。

I suspect you don't really understand the original sentence, because
the translated text isn't understandable at all.

"在打开lockdep功能的情况下，所有的代码路径都被运行过。"

>  
[snip]
