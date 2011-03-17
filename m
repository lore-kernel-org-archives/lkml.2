Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab1CQOaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 10:30:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63168 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab1CQOan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 10:30:43 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=2-_pf7bKywUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=meVymXHHAAAA:8 a=Qluxk-LBlLVSYSfvjjoA:9 a=YmSsoxOO-q2pWaBRQd8u4IcnPB8A:4 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [tip:perf/urgent] trace, documentation: Fix branch profiling
 location in debugfs
From: Steven Rostedt <rostedt@goodmis.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rientjes@google.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-13e5befaddcf8d542ae45610b552105490a0010b@git.kernel.org>
References: <alpine.DEB.2.00.1103161716320.11407@chino.kir.corp.google.com>
	 <tip-13e5befaddcf8d542ae45610b552105490a0010b@git.kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Mar 2011 10:30:41 -0400
Message-ID: <1300372241.16880.119.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 11:04 +0000, tip-bot for David Rientjes wrote:
> Commit-ID:  13e5befaddcf8d542ae45610b552105490a0010b
> Gitweb:     http://git.kernel.org/tip/13e5befaddcf8d542ae45610b552105490a0010b
> Author:     David Rientjes <rientjes@google.com>
> AuthorDate: Wed, 16 Mar 2011 17:17:08 -0700
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 17 Mar 2011 09:10:45 +0100

Heh, I added this on top of the jump label patches that I'm testing.
I'll just remove it ;)

-- Steve

> 
> trace, documentation: Fix branch profiling location in debugfs
> 
> The debugfs interface for branch profiling is through
> 
> 	/sys/kernel/debug/tracing/trace_stat/branch_annotated
> 	/sys/kernel/debug/tracing/trace_stat/branch_all
> 
> so update the Kconfig accordingly.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> LKML-Reference: <alpine.DEB.2.00.1103161716320.11407@chino.kir.corp.google.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/trace/Kconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 14674dc..61d7d59f 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -275,7 +275,7 @@ config PROFILE_ANNOTATED_BRANCHES
>  	  This tracer profiles all the the likely and unlikely macros
>  	  in the kernel. It will display the results in:
>  
> -	  /sys/kernel/debug/tracing/profile_annotated_branch
> +	  /sys/kernel/debug/tracing/trace_stat/branch_annotated
>  
>  	  Note: this will add a significant overhead; only turn this
>  	  on if you need to profile the system's use of these macros.
> @@ -288,7 +288,7 @@ config PROFILE_ALL_BRANCHES
>  	  taken in the kernel is recorded whether it hit or miss.
>  	  The results will be displayed in:
>  
> -	  /sys/kernel/debug/tracing/profile_branch
> +	  /sys/kernel/debug/tracing/trace_stat/branch_all
>  
>  	  This option also enables the likely/unlikely profiler.
>  


