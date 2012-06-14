Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab2FNXNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:13:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:33746 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab2FNXMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:12:44 -0400
Date: Fri, 15 Jun 2012 01:12:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] tracing: Fix the outmost stupidity of tracing_off()
In-Reply-To: <1339714725.13377.252.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1206150106511.3086@ionos>
References: <alpine.LFD.2.02.1206142345100.3086@ionos> <1339714725.13377.252.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012, Steven Rostedt wrote:

> On Fri, 2012-06-15 at 00:47 +0200, Thomas Gleixner wrote:
> > I lost another day of waiting for a complex bug to trigger and turn
> > off tracing, which did not happen due to:
> > 
> >  commit 499e54705(tracing/ring-buffer: Only have tracing_on disable
> >  tracing buffers)
> 
> I submitted this last week: https://lkml.org/lkml/2012/6/6/701

And how does that make up for a lost day?
 
> I forgot to Cc you.

That's still not an excuse for utter stupidity, really. Just check the
commit date vs. your discovery time.

I told you often enough to be more careful, but that one is really
beyond comprehension.

       Thomas
