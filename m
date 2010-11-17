Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935218Ab0KQSMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 13:12:25 -0500
Received: from mail.openrapids.net ([64.15.138.104]:44499 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758512Ab0KQSMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 13:12:24 -0500
Date: Wed, 17 Nov 2010 13:12:22 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>, Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 1/5] [PATCH 1/5] events: Add EVENT_FS the event
	filesystem
Message-ID: <20101117181222.GB1093@Krystal>
References: <20101117005357.024472450@goodmis.org> <20101117005939.600541101@goodmis.org> <20101117033242.GB31335@suse.de> <20101117103914.GA21976@elte.hu> <1289996753.30543.35.camel@gandalf.stny.rr.com> <20101117174652.GC13717@Krystal> <1290016354.30543.71.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290016354.30543.71.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:11:55 up 55 days, 22:14,  6 users,  load average: 0.17, 0.12,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2010-11-17 at 12:46 -0500, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > [...]
> > > Are these events now going to be labeled as stable?  Is every tracepoint
> > > we have, much have the same data?  Linus specifically said at Kernel
> > > Summit that he wants absolutely NO modules to have a stable tracepoint.
> > 
> > I'd like to bring up the point of KVM tracepoints here. KVM can be configured as
> > a module, and may clearly contain tracepoints that we'd like to be stable.
> > 
> > My thought is that what we really want to enforce is "no stable tracepoints in
> > drivers" rather than in "modules", but I might be wrong.
> > 
> > Thoughts ?
> 
> I still say no to stable tracepoints in modules. Once you open that
> door, everyone will have it.
> 
> But, that doesn't mean that a raw traepoint can't be stable. If the
> maintainer of that tracepoint states it is stable, then by all means,
> let tools use it.

I'd really like to hear Avi's thoughts on this.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
