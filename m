Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab2H0AH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 20:07:29 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:36795 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab2H0AH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 20:07:28 -0400
Date: Mon, 27 Aug 2012 09:07:20 +0900
From: Simon Horman <horms@verge.net.au>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: ebiederm@xmission.com, yongjun_wei@trendmicro.com.cn,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdump: remove unused including <generated/utsrelease.h>
Message-ID: <20120827000720.GA27105@verge.net.au>
References: <CAPgLHd_ndLkDD7Q1WyqHifMYek9U3-cY0xrNdWfu+tfiDtiHdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd_ndLkDD7Q1WyqHifMYek9U3-cY0xrNdWfu+tfiDtiHdw@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 10:18:20AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> 
> Remove including <generated/utsrelease.h> that don't need it.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Reviewed-by: Simon Horman <horms@verge.net.au

Andrew, could you consider picking this up?

> ---
>  kernel/kexec.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 0668d58..5e4bd78 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -21,7 +21,6 @@
>  #include <linux/hardirq.h>
>  #include <linux/elf.h>
>  #include <linux/elfcore.h>
> -#include <generated/utsrelease.h>
>  #include <linux/utsname.h>
>  #include <linux/numa.h>
>  #include <linux/suspend.h>
> 
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 
