Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab0KRL6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:58:16 -0500
Received: from mail.openrapids.net ([64.15.138.104]:43208 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751130Ab0KRL6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:58:15 -0500
Date: Thu, 18 Nov 2010 06:58:12 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "jason.wessel" <jason.wessel@windriver.com>,
        "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [RFC][PATCH 2/2] [PATCH 2/2] tracing: Make event based
	trace_printk()
Message-ID: <20101118115812.GA27474@Krystal>
References: <20101118035803.453609353@goodmis.org> <20101118040949.782054673@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118040949.782054673@goodmis.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 06:57:00 up 56 days, 15:59,  1 user,  load average: 1.49, 1.33,
	1.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Add the trace_printk() that places the usage in the
> /debug/tracing/events/printk directory.
> 
> Adding a trace_printk() into sched.c at line 2181, we have:

I'm curious: how do you handle two trace_printk on the same line ?

It might be OK to let the interface activate both at once, but nothing should
crash per se.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
