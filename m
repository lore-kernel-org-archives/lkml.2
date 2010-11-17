Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab0KQXsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:48:45 -0500
Received: from THUNK.ORG ([69.25.196.29]:51440 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab0KQXsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:48:43 -0500
Date: Wed, 17 Nov 2010 18:48:33 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 1/5] [PATCH 1/5] events: Add EVENT_FS the event
 filesystem
Message-ID: <20101117234833.GK3290@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
	Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20101117005357.024472450@goodmis.org>
 <20101117005939.600541101@goodmis.org>
 <20101117033242.GB31335@suse.de>
 <20101117103914.GA21976@elte.hu>
 <1289996753.30543.35.camel@gandalf.stny.rr.com>
 <20101117174652.GC13717@Krystal>
 <1290016354.30543.71.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290016354.30543.71.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 12:52:34PM -0500, Steven Rostedt wrote:
> 
> I still say no to stable tracepoints in modules. Once you open that
> door, everyone will have it.

What about having KVM define the stable tracepoints in the built-in
part of the kernel, if CONFIG_KVM is Y or M, and then export the
tracepoints, such that the tracepoints can be called from a module?

That way the tracepoints aren't being *defined* in a module, they are
just being *called* from the module.  Does that seem like a reasonable
compromise?

						- Ted
