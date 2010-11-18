Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab0KRMOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:14:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38485 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab0KRMOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:14:49 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=v8ohC7cffDsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=oeUOMsKwP6GX-EH4SG0A:9 a=XDNKQuVOY2D5zYMVjx-tMMA1gasA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 2/2] [PATCH 2/2] tracing: Make event based
 trace_printk()
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "jason.wessel" <jason.wessel@windriver.com>,
        "Ted Ts'o" <tytso@mit.edu>
In-Reply-To: <20101118115812.GA27474@Krystal>
References: <20101118035803.453609353@goodmis.org>
	 <20101118040949.782054673@goodmis.org>  <20101118115812.GA27474@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 18 Nov 2010 07:14:47 -0500
Message-ID: <1290082487.30543.99.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 06:58 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Add the trace_printk() that places the usage in the
> > /debug/tracing/events/printk directory.
> > 
> > Adding a trace_printk() into sched.c at line 2181, we have:
> 
> I'm curious: how do you handle two trace_printk on the same line ?
> 
> It might be OK to let the interface activate both at once, but nothing should
> crash per se.

You get 2181, and 2181-1

-- Steve


