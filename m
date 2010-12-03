Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab0LCO77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:59:59 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49611 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab0LCO76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:59:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iH4gacmRBn2UfqNdtmUXtzdoERYLX2wEqtbzIH5UFhfZBI12mXMlaMTQAfwj0tcmKn
         w0bfUYJL0229MRCtS7maPkKUL6mRDsoB8rPm/M/NNBDD61bw1UxD1t5ZoDDTuGNmZFKN
         BMdsVTINs/x9a21IrJL8ZEkBIZkWHxCtG7NNA=
Date: Fri, 3 Dec 2010 15:59:53 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [RFC][PATCH 0/2 v2] tracing: Add conditional to tracepoints
Message-ID: <20101203145950.GB1711@nowhere>
References: <20101203040358.955427199@goodmis.org>
 <20101203144720.GA1711@nowhere>
 <1291387992.3228.6.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291387992.3228.6.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 09:53:12AM -0500, Steven Rostedt wrote:
> On Fri, 2010-12-03 at 15:47 +0100, Frederic Weisbecker wrote:
> 
> > Looks good
> > 
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > I suspect we'll need to fix some scripts/subperf commands in perf. Those that do:
> > 
> > 	if (success)
> > 
> > tests after reading a trace from a wakeup event.
> 
> I  guess the question is, is that "success" part of the ABI or not?


The fact is: if old tools read new sched wakeup traces, the tools won't work.

Now the debate is always the same.
