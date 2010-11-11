Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab0KKJLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 04:11:43 -0500
Received: from www.tglx.de ([62.245.132.106]:54119 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab0KKJLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 04:11:41 -0500
Date: Thu, 11 Nov 2010 10:10:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Sharp <dhsharp@google.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFD tracing] Tracing ABI Work Plan
In-Reply-To: <1289441127.12418.222.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1011111010160.2900@localhost6.localdomain6>
References: <20101111004612.GB32564@Krystal>  <alpine.LFD.2.00.1011110158390.2900@localhost6.localdomain6>  <1289440255.12418.218.camel@gandalf.stny.rr.com>  <alpine.LFD.2.00.1011110251580.2900@localhost6.localdomain6>
 <1289441127.12418.222.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010, Steven Rostedt wrote:
> On Thu, 2010-11-11 at 02:55 +0100, Thomas Gleixner wrote:
> > On Wed, 10 Nov 2010, Steven Rostedt wrote:
> > > On Thu, 2010-11-11 at 02:33 +0100, Thomas Gleixner wrote:
> > > 
> > > > Either that or you immediately install the "Work Plan Committee" which
> > > > will make sure that there will be no progress ever.
> > > 
> > > Oooo ooo oo, I want to be on this committee!!!
> > > 
> > > Get Mathieu and I there, and we can guarantee no work will ever
> > > happen ;-)
> > 
> > Hereby you and Mathieu are appointed to the "Work Plan Committee". By
> > accepting that appointment you promise to stay away from real kernel
> > tracing problems forever and restrict yourself to an annual "no
> > progress" report.
> > 
> > Thanks,
> > 
> > 	tglx
> > ---
> > P.S.: It would be more funny, if it wouldn't be close to reality!
> 
> So be it...

NAK. Just running away is not a technical solution.

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0094224..96850d6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5889,7 +5889,6 @@ S:	Maintained
>  F:	drivers/char/tpm/
>  
>  TRACING
> -M:	Steven Rostedt <rostedt@goodmis.org>
>  M:	Frederic Weisbecker <fweisbec@gmail.com>
>  M:	Ingo Molnar <mingo@redhat.com>
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf/core
> 
> 
