Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab0IIR0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 13:26:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43813 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab0IIR0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 13:26:20 -0400
Date: Thu, 9 Sep 2010 19:26:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 0/5] perf/urgent probe fixes
Message-ID: <20100909172602.GA31642@elte.hu>
References: <1284052005-25658-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284052005-25658-1-git-send-email-acme@infradead.org>
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

> Hi Ingo,
> 
>         Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent
> 
> Regards,
> 
> - Arnaldo
> 
> Masami Hiramatsu (5):
>   tracing/kprobe: Fix a memory leak in error case
>   perf probe: Fix return probe support
>   perf probe: Fix handling of arguments names
>   tracing/kprobes: Fix handling of argument names
>   tracing/kprobe: Fix handling of C-unlike argument names
> 
>  kernel/trace/trace_kprobe.c    |   43 +++++++++++++++++++++++----------------
>  tools/perf/util/probe-event.c  |    1 +
>  tools/perf/util/probe-finder.c |   42 +++++++++++++++++++++++++++------------
>  3 files changed, 55 insertions(+), 31 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
