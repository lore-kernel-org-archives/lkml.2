Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab0KRNFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:05:06 -0500
Received: from mail.openrapids.net ([64.15.138.104]:59011 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756815Ab0KRNFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:05:04 -0500
Date: Thu, 18 Nov 2010 08:05:02 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Ted Ts'o" <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>
Subject: Re: [RFC][PATCH 1/5] [PATCH 1/5] events: Add EVENT_FS the event
	filesystem
Message-ID: <20101118130502.GC3741@Krystal>
References: <20101117005357.024472450@goodmis.org> <20101117005939.600541101@goodmis.org> <20101117033242.GB31335@suse.de> <20101117103914.GA21976@elte.hu> <1289996753.30543.35.camel@gandalf.stny.rr.com> <20101117174652.GC13717@Krystal> <1290016354.30543.71.camel@gandalf.stny.rr.com> <20101117234833.GK3290@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117234833.GK3290@thunk.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 08:03:37 up 56 days, 17:05,  1 user,  load average: 1.61, 1.39,
	1.26
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ted Ts'o (tytso@mit.edu) wrote:
> On Wed, Nov 17, 2010 at 12:52:34PM -0500, Steven Rostedt wrote:
> > 
> > I still say no to stable tracepoints in modules. Once you open that
> > door, everyone will have it.
> 
> What about having KVM define the stable tracepoints in the built-in
> part of the kernel, if CONFIG_KVM is Y or M, and then export the
> tracepoints, such that the tracepoints can be called from a module?
> 
> That way the tracepoints aren't being *defined* in a module, they are
> just being *called* from the module.  Does that seem like a reasonable
> compromise?

As Avi replied separately, he does not seem to think stable ABI is needed for
KVM, given that his tools can deal with tracepoint addition/removal pretty well.
However, let's keep this idea in mind if we ever face this issue with other
"core" modules.

Thanks Ted,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
