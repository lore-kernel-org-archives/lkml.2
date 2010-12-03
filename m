Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab0LCP1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:27:38 -0500
Received: from mail.openrapids.net ([64.15.138.104]:35235 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751349Ab0LCP1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:27:37 -0500
Date: Fri, 3 Dec 2010 10:27:33 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC][PATCH 1/2 v2] tracing: Add TRACE_EVENT_CONDITIONAL()
Message-ID: <20101203152733.GA25580@Krystal>
References: <20101203040358.955427199@goodmis.org> <20101203040822.144348122@goodmis.org> <20101203045402.GA29609@Krystal> <1291385344.3228.4.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291385344.3228.4.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:23:47 up 9 days, 20:26,  3 users,  load average: 0.06, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2010-12-02 at 23:54 -0500, Mathieu Desnoyers wrote:
[...]
> > 
> > One small documentation-related detail: my guess is that you are leaving
> > "cond" without likely/unlikely builtin expect purposefully so that we
> > can write, in TP_CONDITION:
> > 
> >   TP_CONDITION(unlikely(someparam)),
> 
> I actually think this is an abuse of "unlikely".

Why are you considering this an abuse ?

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
