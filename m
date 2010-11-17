Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793Ab0KQW4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:56:55 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:41172 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935576Ab0KQW4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:56:54 -0500
Message-ID: <1290034589.4ce45d9d7be28@www.imp.polymtl.ca>
Date: Wed, 17 Nov 2010 17:56:29 -0500
From: Douglas Santos <douglas.santos@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>,
        David Sharp <dhsharp@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>
Subject: Re: Benchmarks of kernel tracing options 2 (ftrace, lttng and perf)
References: <1290029498.4ce449ba1679d@www.imp.polymtl.ca> <1290030106.30543.74.camel@gandalf.stny.rr.com>
In-Reply-To: <1290030106.30543.74.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.3
X-Originating-IP: 70.55.65.249
X-Poly-FromMTA: (imp-4-3.polymtl.ca [132.207.4.78]) at Wed, 17 Nov 2010 22:56:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Steven Rostedt <rostedt@goodmis.org>:

> On Wed, 2010-11-17 at 16:31 -0500, Douglas Santos wrote:
> > Hi all,
> >
> > This is a response to a benchmark, submitted a few weeks ago, comparing
> kernel
> > tracing options.
> > http://lkml.org/lkml/2010/10/28/422
> >
> > We followed the methodology described in the link bellow,
> > but using the shellscripts posted there to reproduce autotest scripts.
> > http://lkml.org/lkml/2010/10/28/261
> >
> > We disabled the extra syscall tracing on lttng, for a fair comparison.
> > http://lkml.org/lkml/2010/10/28/290
> >
> > Average results with tracing "on":
> >
> > lttng:  220 ns
> > ftrace: 260 ns
>
> Heh, so ftrace got worse with the new kernel?

The previous bench was doing tracing "on" minus "off"
average results. They also used autotest scripts, not sure if
it does exactly the same thing.

I'll check if we missed something.


