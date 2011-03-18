Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab1CRPaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:30:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52757 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab1CRPaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:30:04 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=XYJHFtupD_QA:10 a=2f1-j1pq85wA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=VVvw4wU-dGQwIfGSMBsA:9 a=_33E2IByhTy9Xd3Bij8A:7 a=EI1drTsvjlTAlublFQJTckpsxTUA:4 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=MSl-tDqOz04A:10 a=TmBZ8bNFSUE84GdN:21 a=_vrz7lri0-xXMaw0:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Fri, 18 Mar 2011 11:29:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [RFC 2/2] x86, dumpstack: use %pT format specifier for stack
 trace
Message-ID: <20110318152959.GJ14675@home.goodmis.org>
References: <1300447278-2073-1-git-send-email-namhyung@gmail.com>
 <1300447278-2073-3-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300447278-2073-3-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You needed to add the x86 maintainers to your Cc list.

-- Steve

On Fri, Mar 18, 2011 at 08:21:18PM +0900, Namhyung Kim wrote:
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  arch/x86/kernel/dumpstack.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
> index 914065620f2c..809d027de28f 100644
> --- a/arch/x86/kernel/dumpstack.c
> +++ b/arch/x86/kernel/dumpstack.c
> @@ -27,7 +27,7 @@ static int die_counter;
>  
>  void printk_address(unsigned long address, int reliable)
>  {
> -	printk(" [<%p>] %s%pS\n", (void *) address,
> +	printk(" [<%p>] %s%pT\n", (void *) address,
>  			reliable ? "" : "? ", (void *) address);
>  }
>  
> -- 
> 1.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
