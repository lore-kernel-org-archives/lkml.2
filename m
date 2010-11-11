Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab0KKM0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:26:53 -0500
Received: from mail.openrapids.net ([64.15.138.104]:43288 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756512Ab0KKM0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:26:51 -0500
Date: Thu, 11 Nov 2010 07:26:46 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Sharp <dhsharp@google.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC tracing] Common Trace Format for Linux (v1.1)
Message-ID: <20101111122645.GA3992@Krystal>
References: <20101111004612.GB32564@Krystal> <alpine.LFD.2.00.1011110158390.2900@localhost6.localdomain6> <20101111021614.GA5782@Krystal> <alpine.LFD.2.00.1011111011530.2900@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011111011530.2900@localhost6.localdomain6>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 07:25:52 up 49 days, 16:28,  1 user,  load average: 1.41, 1.29,
	1.21
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> Mathieu,
> 
> On Wed, 10 Nov 2010, Mathieu Desnoyers wrote:
> 
> > * Thomas Gleixner (tglx@linutronix.de) wrote:
> > [...]
> > 
> > > The requirement list has been beaten to death several times already
> > > along with the various options of trace formats, so we really are at
> > > the point where you folks need to sit down and come up with real code
> > > which can be discussed and improved on a technical base.
> > 
> > I understand and share your frustration about things having been standing still
> > for way too long.
> > 
> > In order to get things rolling, I hereby append my trace format proposal as RFC.
> > I did implement the core elements of it already in the BabelTrace trace
> > converter project, so it's not one of these dreaded "design by committee without
> > any understanding of the practicality aspects" standards. I try make sure it
> > translates to something realistic and useful.
> > 
> > Feedback is welcome, thanks,
> > 
> > Mathieu
> > 
> > RFC: Common Trace Format Proposal for Linux (v1.1)
> 
> Groan. Did you read what I wrote ?
> 
> > >                                              ... so we really are at
> > > the point where you folks need to sit down and come up with real code
> > > which can be discussed and improved on a technical base.
> 
> Your reaction on this is to send yet another proposal, which has not
> really anything new in it.
> 
> What we are waiting for is a sensible incremental patch series, which
> extends or replaces functionality in the existing perf ABI up to the
> point, where we can eventually see the need for a sensible
> replacement. That's the way we work, not with tons of proposals.

OK, I'll work on this. Meanwhile, anyone interested to provide feedback on the
RFC I sent is still welcome to do so.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
