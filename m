Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab0JUOrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:47:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58376 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852Ab0JUOoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:44:16 -0400
Date: Thu, 21 Oct 2010 16:43:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
Message-ID: <20101021144346.GB10694@elte.hu>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com>
 <20101019184111.GA17266@elte.hu>
 <20101020154045.GA18353@elte.hu>
 <1287659656.16971.573.camel@gandalf.stny.rr.com>
 <20101021112614.GB26984@elte.hu>
 <20101021135521.GB2920@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021135521.GB2920@redhat.com>
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


* Jason Baron <jbaron@redhat.com> wrote:

> > > Looks like this code had jump labels enabled. Do you have a dump where they 
> > > are not enabled?
> > 
> > No. Good find - and the timeline agrees too, these crashes started triggering 
> > when i pulled jump labels from you.
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> indeed. I can re-produce reliably as well on x86...hmmm, I have done stress 
> testing where I basically just enable/disable all the tracepoints in a tight loop 
> and never saw this...but I mostly have been testing on x86_64.

Dont worry about that too much - there will always be bugs that can only be found in 
some special way. Good thing we had the self-tests. (and even those didnt reliably 
trigger it for me)

Thanks,

	Ingo
