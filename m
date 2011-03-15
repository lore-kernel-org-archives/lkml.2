Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856Ab1COUZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:25:32 -0400
Received: from www.tglx.de ([62.245.132.106]:37783 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab1COUZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:25:30 -0400
Date: Tue, 15 Mar 2011 21:09:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 0/20] 0: Inode based uprobes
In-Reply-To: <1300219261.9910.300.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1103152102430.2787@localhost6.localdomain6>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>  <20110314163028.a05cec49.akpm@linux-foundation.org>  <20110314234754.GP2499@one.firstfloor.org>  <alpine.LFD.2.00.1103150114590.2787@localhost6.localdomain6> 
 <20110315180639.GQ2499@one.firstfloor.org>  <alpine.LFD.2.00.1103152038280.2787@localhost6.localdomain6> <1300219261.9910.300.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011, Steven Rostedt wrote:

> On Tue, 2011-03-15 at 20:43 +0100, Thomas Gleixner wrote:
> > On Tue, 15 Mar 2011, Andi Kleen wrote:
> > > > > How do you envisage these features actually get used?  For example,
> > > > > will gdb be modified?  Will other debuggers be modified or written?
> > > > 
> > > > How about answering this question first _BEFORE_ advertising
> > > > systemtap?
> > > 
> > > I thought this was obvious.  systemtap is essentially a script driven 
> > > debugger. 
> > 
> > Oh thanks for the clarification. I always wondered why a computer
> > would need a tap.
> > 
> > And it does not matter at all whether systemtap can use this or
> > not. If the main debuggers used like gdb are not going to use it then
> > it's a complete waste. We don't need another debugging interface just
> > for a single esoteric use case.
> 
> The question is, can we have a tracing interface? I don't care about a
> debugging interface as PTRACE (although the ABI sucks) is fine for that.
> But any type of live tracing it really sucks for.
> 
> Hopefully this will allow perf (and yes even LTTng and systemtap) to be
> finally able to do seamless tracing between userspace and kernel space.
> The only other thing we have now is PTRACE, and if you think that's
> sufficient, then spend a day programming with it.

I didn't say that ptrace rocks.

All I'm saying is that we want a better argument than a single user
which is - and yes i tried it more than once - assbackwards beyond all
imagination.

If gdb, perf, trace can and will make use of it then we have sensible
arguments enough to go there. If systemtap can use it as well then I
have no problem with that..

Thanks,

	tglx
