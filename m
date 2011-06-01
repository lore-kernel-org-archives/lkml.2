Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086Ab1FABLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 21:11:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44251 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005Ab1FABLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 21:11:23 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=HYZG5H_0JlQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=XVEu4Z2iH2z3UE8rlXIA:9 a=k5q-nt2qRbLYhqgB-7IA:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] KERNEL: async: Fixed an include coding style issue
From: Steven Rostedt <rostedt@goodmis.org>
To: Paul McQuade <tungstentide@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4DE58D24.7070309@gmail.com>
References: <4DE58D24.7070309@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 31 May 2011 21:11:20 -0400
Message-ID: <1306890680.10135.14.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 01:51 +0100, Paul McQuade wrote:
> >From 2514174efe73e654c46e669ea2df5169a41d0130 Mon Sep 17 00:00:00 2001
> From: Paul McQuade <tungstentide@gmail.com>
> Date: Tue, 31 May 2011 20:51:55 +0100
> Subject: [PATCH] KERNEL: async: Fixed an include coding style issue
>  KERNEL: trace: ftrace: Fixed an include coding style issue
> 
> async:
> Added <linux/atomic.h>,<linux/ktime.h> and Removed <asm/atomic.h>.
> Added KERN_DEBUG to printk() functions.

The async changes need to be separate from the ftrace changes.

Just make two patches.

> 
> ftrace:
> Removed <asm/ftrace.h> because <linux/ftrace.h> was already declared.
> Braces of struct's coding style fixed.

> Signed-off-by: Paul McQuade <tungstentide@gmail.com>
> ---
>  kernel/async.c        |   13 +++++++------
>  kernel/trace/ftrace.c |   12 ++++--------
>  2 files changed, 11 insertions(+), 14 deletions(-)



> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 1ee417f..02c1cef 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -32,7 +32,6 @@
> 
>  #include <trace/events/sched.h>
> 
>  };


> 
>  #define ENTRIES_PER_PAGE \
> -  ((PAGE_SIZE - sizeof(struct ftrace_page)) / sizeof(struct dyn_ftrace))
> +((PAGE_SIZE - sizeof(struct ftrace_page)) / sizeof(struct dyn_ftrace))

I'm fine with all the ftrace.c changes but this one. I like the
indentation here, as it makes it easier to read that it is a
continuation of the previous line.

-- Steve


