Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1BBWUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:20:55 -0500
Received: from www.tglx.de ([62.245.132.106]:60464 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab1BBWUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:20:54 -0500
Date: Wed, 2 Feb 2011 23:20:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/2] Tracepoints: Fix section alignment using pointer
 array
In-Reply-To: <1296673015.10797.66.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1102022318520.31804@localhost6.localdomain6>
References: <20110202180613.978219945@goodmis.org>  <20110202180938.471738176@goodmis.org>  <20110202183138.GB27022@Krystal> <1296673015.10797.66.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Feb 2011, Steven Rostedt wrote:

> On Wed, 2011-02-02 at 13:31 -0500, Mathieu Desnoyers wrote:
> 
> > > History:
> > > 
> > > commit 7e066fb870fcd1025ec3ba7bbde5d541094f4ce1 added the aligned(32) type and
> > > variable attribute to the tracepoint structures to deal with gcc happily
> > > aligning statically defined structures on 32-byte multiples.
> > > 
> > > commit 15e3540ce2159705f18fad6147ffedf04445ad64 tried to use a 8-byte alignment
> > > for tracepoint structures by applying both the variable and type attribute to
> > > tracepoint structures definitions and declarations. It worked fine with gcc
> > > 4.5.1, but broke with gcc 4.4.4 and 4.4.5.
> > 
> > Small nit: this reference to commit 15e3540ce2159705f18fad6147ffedf04445ad64
> > should be changed to a non-commit-id-related explanation, because the commit has
> > been rolled back from -tip.
> 
> OK, I just did a git commit --amend to fix it. Here's the new text:
> 
> 
>     commit 7e066fb870fcd1025ec3ba7bbde5d541094f4ce1 added the aligned(32) type a

Can you please use the common format

    commit 7e066fb8(what ever the subject line of the commit was)

That's way more helpful than a full sha1.

Thanks,

	tglx
