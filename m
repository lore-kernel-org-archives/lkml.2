Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab2BFRdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:33:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63050 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2BFRdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:33:53 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=79GWP_J3dGsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=0azM3ZO7AAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=n_LHOsng7RYitGx65FoA:9 a=KV7yX-cy4a0KrMFuYsAA:7 a=PUjeQqilurYA:10 a=BGWj8ct6lkoA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328549630.2200.19.camel@gandalf.stny.rr.com>
Subject: Re: [tip:perf/urgent] trace events: Update version number reference
 to new 3.x scheme for EVENT_POWER_TRACING_DEPRECATED
From: Steven Rostedt <rostedt@goodmis.org>
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, jj@chaosbits.net, tglx@linutronix.de,
        mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 06 Feb 2012 12:33:50 -0500
In-Reply-To: <tip-f629299b544b6cc12b4e3e85fec96f4ce5809482@git.kernel.org>
References: <alpine.LNX.2.00.1107250929370.8080@swampdragon.chaosbits.net>
	 <tip-f629299b544b6cc12b4e3e85fec96f4ce5809482@git.kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 20:06 +0000, tip-bot for Jesper Juhl wrote:
> Commit-ID:  f629299b544b6cc12b4e3e85fec96f4ce5809482
> Gitweb:     http://git.kernel.org/tip/f629299b544b6cc12b4e3e85fec96f4ce5809482
> Author:     Jesper Juhl <jj@chaosbits.net>
> AuthorDate: Sun, 24 Jul 2011 23:15:42 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 25 Jul 2011 09:37:21 +0200
> 
> trace events: Update version number reference to new 3.x scheme for EVENT_POWER_TRACING_DEPRECATED
> 
> What was scheduled to be 2.6.41 is now going to be 3.1 .

I see the comment here also states that this code would be removed in
3.1, where as we are now heading towards 3.3 and Arjan said it doesn't
hurt to keep the code.

I guess this comment needs to be removed too?

-- Steve

> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Link: http://lkml.kernel.org/r/alpine.LNX.2.00.1107250929370.8080@swampdragon.chaosbits.net
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/trace/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 2ad39e5..cd31345 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -82,7 +82,7 @@ config EVENT_POWER_TRACING_DEPRECATED
>  	  power:power_frequency
>  	  This is for userspace compatibility
>  	  and will vanish after 5 kernel iterations,
> -	  namely 2.6.41.
> +	  namely 3.1.
>  
>  config CONTEXT_SWITCH_TRACER
>  	bool


