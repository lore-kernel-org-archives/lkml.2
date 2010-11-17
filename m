Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935141Ab0KQRq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:46:56 -0500
Received: from mail.openrapids.net ([64.15.138.104]:59299 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934635Ab0KQRqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:46:54 -0500
Date: Wed, 17 Nov 2010 12:46:52 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
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
Message-ID: <20101117174652.GC13717@Krystal>
References: <20101117005357.024472450@goodmis.org> <20101117005939.600541101@goodmis.org> <20101117033242.GB31335@suse.de> <20101117103914.GA21976@elte.hu> <1289996753.30543.35.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289996753.30543.35.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:43:59 up 55 days, 21:46,  5 users,  load average: 0.14, 0.12,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
[...]
> Are these events now going to be labeled as stable?  Is every tracepoint
> we have, much have the same data?  Linus specifically said at Kernel
> Summit that he wants absolutely NO modules to have a stable tracepoint.

I'd like to bring up the point of KVM tracepoints here. KVM can be configured as
a module, and may clearly contain tracepoints that we'd like to be stable.

My thought is that what we really want to enforce is "no stable tracepoints in
drivers" rather than in "modules", but I might be wrong.

Thoughts ?

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
