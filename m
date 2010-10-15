Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab0JOTzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:55:46 -0400
Received: from mail.openrapids.net ([64.15.138.104]:45918 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932413Ab0JOTzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:55:45 -0400
Date: Fri, 15 Oct 2010 15:55:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH] kernel: trace: trace_kprobe.c: removed duplicated
	#include
Message-ID: <20101015195538.GC2521@Krystal>
References: <1287170842-20279-1-git-send-email-andrea.gelmini@gelma.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287170842-20279-1-git-send-email-andrea.gelmini@gelma.net>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:54:58 up 22 days, 23:57,  5 users,  load average: 0.09, 0.07,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrea Gelmini (andrea.gelmini@gelma.net) wrote:
> Removed linux/uaccess.h

... and cleans up a whitespace.

Mathieu

> 
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> ---
>  kernel/trace/trace_kprobe.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 544301d..c5fb747 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -18,7 +18,6 @@
>   */
>  
>  #include <linux/module.h>
> -#include <linux/uaccess.h>
>  #include <linux/kprobes.h>
>  #include <linux/seq_file.h>
>  #include <linux/slab.h>
> @@ -479,7 +478,7 @@ struct probe_arg {
>  struct trace_probe {
>  	struct list_head	list;
>  	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
> -	unsigned long 		nhit;
> +	unsigned long		nhit;
>  	unsigned int		flags;	/* For TP_FLAG_* */
>  	const char		*symbol;	/* symbol name */
>  	struct ftrace_event_class	class;
> -- 
> 1.7.3.1.181.g784b8
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
