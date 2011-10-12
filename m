Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab1JLHJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 03:09:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57645 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab1JLHJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 03:09:44 -0400
Date: Wed, 12 Oct 2011 09:08:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH 0/2] [GIT PULL][v3.1] kprobes: can cause perf to crash
 the system
Message-ID: <20111012070808.GD18618@elte.hu>
References: <20111010191706.044816068@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010191706.044816068@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> I tested and verified that the commends that Masami has shown will
> crash the system. These patches do fix the problem.
> 
> I also verified that the same commands will crash 2.6.39 and have included
> stable in the Cc of the commits.
> 
> -- Steve
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/urgent
> 
> Head SHA1: 44a56040a0037a845d5fa218dffde464579f0cab
> 
> 
> Masami Hiramatsu (2):
>       ftrace/kprobes: Fix not to delete probes if in use
>       perf probe: Fix to show correct error string
> 
> ----
>  kernel/trace/trace_kprobe.c   |   58 ++++++++++++++++++++++++++++++++++------
>  tools/perf/util/probe-event.c |    4 ++-
>  2 files changed, 52 insertions(+), 10 deletions(-)

Pulled, thanks a lot guys!

	Ingo
