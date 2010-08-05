Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759790Ab0HEGqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:46:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60655 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756669Ab0HEGqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:46:33 -0400
Date: Thu, 5 Aug 2010 08:46:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Dave Martin <dave.martin@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Will Deacon <Will.Deacon@arm.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL 0/3] perf/core fixes and improvements
Message-ID: <20100805064606.GA30292@elte.hu>
References: <1280957164-14274-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280957164-14274-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> 
> Hi Ingo,
> 
>         Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> Dave Martin (1):
>   perf events: Fix mmap offset determination
> 
> Srikar Dronamraju (2):
>   perf: expose event__process function
>   tracing/kprobes: unregister_trace_probe needs to be called under mutex
> 
>  kernel/trace/trace_kprobe.c |    3 +++
>  tools/perf/builtin-top.c    |   20 --------------------
>  tools/perf/util/event.c     |   28 +++++++++++++++++++++-------
>  tools/perf/util/event.h     |    1 +
>  4 files changed, 25 insertions(+), 27 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
