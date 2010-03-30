Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab0C3Nuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 09:50:50 -0400
Received: from mail.openrapids.net ([64.15.138.104]:35503 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752139Ab0C3Nut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 09:50:49 -0400
Date: Tue, 30 Mar 2010 09:50:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable <stable@kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] modules fix incorrect percpu usage
Message-ID: <20100330135047.GB20673@Krystal>
References: <20100330033211.GC7683@Krystal> <20100330033617.GE7683@Krystal> <1269955201.19685.5867.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269955201.19685.5867.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:50:34 up 66 days, 16:27,  9 users,  load average: 0.10, 0.09,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Mon, 2010-03-29 at 23:36 -0400, Mathieu Desnoyers wrote:
> > * Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> > > Should use per_cpu_ptr() to obfuscate the per cpu pointers (RELOC_HIDE is needed
> > > for per cpu pointers).
> > > 
> > > Introduced by commit:
> > > 
> > > module.c: commit 6b588c18f8dacfa6d7957c33c5ff832096e752d3
> > > 
> > > This patch should be queued for the stable branch, for kernels 2.6.29.x to
> > > 2.6.33.x.
> > > (tested on 2.6.33.1 x86_64)
> > 
> > It's actually needed for mainline too (2.6.34-rc2).
> 
> Then all you need to do is submit it for mainline with a 
> "Cc: stable@kernel.org" as you did below. It will then automatically be
> added to the stable queue when Linus pulls it.

OK, thanks for the info.

Mathieu

> 
> -- Steve
> 
> > 
> > Thanks,
> > 
> > Mathieu
> > 
> > > 
> > > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > > CC: Randy Dunlap <randy.dunlap@oracle.com>
> > > CC: Eric Dumazet <dada1@cosmosbay.com>
> > > CC: Rusty Russell <rusty@rustcorp.com.au>
> > > CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > CC: Tejun Heo <tj@kernel.org>
> > > CC: Ingo Molnar <mingo@elte.hu>
> > > CC: Andrew Morton <akpm@linux-foundation.org>
> > > CC: Linus Torvalds <torvalds@linux-foundation.org>
> > > CC: Greg Kroah-Hartman <gregkh@suse.de>
> > > CC: Steven Rostedt <rostedt@goodmis.org>
> > > CC: stable <stable@kernel.org>
> > > ---
> > >  kernel/module.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
