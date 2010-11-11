Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab0KKJp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 04:45:56 -0500
Received: from www.tglx.de ([62.245.132.106]:38640 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab0KKJpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 04:45:54 -0500
Date: Thu, 11 Nov 2010 10:45:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Sharp <dhsharp@google.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC tracing] Common Trace Format for Linux (v1.1)
In-Reply-To: <20101111021614.GA5782@Krystal>
Message-ID: <alpine.LFD.2.00.1011111011530.2900@localhost6.localdomain6>
References: <20101111004612.GB32564@Krystal> <alpine.LFD.2.00.1011110158390.2900@localhost6.localdomain6> <20101111021614.GA5782@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu,

On Wed, 10 Nov 2010, Mathieu Desnoyers wrote:

> * Thomas Gleixner (tglx@linutronix.de) wrote:
> [...]
> 
> > The requirement list has been beaten to death several times already
> > along with the various options of trace formats, so we really are at
> > the point where you folks need to sit down and come up with real code
> > which can be discussed and improved on a technical base.
> 
> I understand and share your frustration about things having been standing still
> for way too long.
> 
> In order to get things rolling, I hereby append my trace format proposal as RFC.
> I did implement the core elements of it already in the BabelTrace trace
> converter project, so it's not one of these dreaded "design by committee without
> any understanding of the practicality aspects" standards. I try make sure it
> translates to something realistic and useful.
> 
> Feedback is welcome, thanks,
> 
> Mathieu
> 
> RFC: Common Trace Format Proposal for Linux (v1.1)

Groan. Did you read what I wrote ?

> >                                              ... so we really are at
> > the point where you folks need to sit down and come up with real code
> > which can be discussed and improved on a technical base.

Your reaction on this is to send yet another proposal, which has not
really anything new in it.

What we are waiting for is a sensible incremental patch series, which
extends or replaces functionality in the existing perf ABI up to the
point, where we can eventually see the need for a sensible
replacement. That's the way we work, not with tons of proposals.

Thanks,

	tglx
