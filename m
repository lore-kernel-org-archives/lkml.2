Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631Ab0ECQNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 12:13:23 -0400
Received: from smtpout.cs.fsu.edu ([128.186.122.75]:23159 "EHLO
	mail.cs.fsu.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758998Ab0ECQNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 12:13:21 -0400
Date: Mon, 3 May 2010 12:13:19 -0400
From: Ted Baker <baker@cs.fsu.edu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: raj@ece.cmu.edu, jayhawk@soe.ucsc.edu, raistlin@linux.it,
       niehaus@ittc.ku.edu, henrik@austad.us, linux-kernel@vger.kernel.org,
       mingo@elte.hu, billh@gnuppy.monkey.org, linux-rt-users@vger.kernel.org,
       fabio@gandalf.sssup.it, anderson@cs.unc.edu, tglx@linutronix.de,
       dhaval.giani@gmail.com, cucinotta@sssup.it, lipari@retis.sssup.it,
       baker.tlh@comcast.net
Subject: Re: [Fwd: Re: RFC for a new Scheduling policy/class in the Linux-kernel]
Message-ID: <20100503161319.GC11020@cs.fsu.edu>
References: <20100426115658.GA21346@cs.fsu.edu> <1272897682.1642.124.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272897682.1642.124.camel@laptop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the complaint about the lklm.org reference.
Somehow, the "2/28/107" portion of the URL got cut off when
I pasted it into my browser. :-}

However, the rest of my comments still apply.

--Ted

On Mon, May 03, 2010 at 04:41:22PM +0200, Peter Zijlstra wrote:
> Hi Ted,
> 
> On Mon, 2010-04-26 at 07:56 -0400, Ted Baker wrote:
> > I have not seen any more e-mail on this.  How is it going?  Is there any
> > chance of rolling in some corrections for the SCHED_SPORADIC treatment?  In
> > particular, could we have a DO_NOT_RUN priority, that is guaranteed to
> > prevent a task from running at all?
> 
> Without having fully read the referenced paper, we're currently looking
> to support the sporadic task model through SCHED_DEADLINE (by our SSSUP
> friends):
> 
>   http://lkml.org/lkml/2010/2/28/107
> 
> This work aims to implement a full sporadic task scheduler [initially
> (g)EDF], SCHED_SPORADIC would have been a better name, but since POSIX
> stole that from us we took SCHED_DEADLINE to indicate its a deadline
> scheduler.
> 
> Along with this work comes the full Deadline-inheritance (which should
> be but a small change from our current Priority-inheritance code), and
> also Bandwidth-inheritance (more work). Esp. the latter would also be
> required for your proposed SCHED_SPORADIC since it does aim to be a
> 'strict' bandwidth enforcing scheduler.
> 
> [Does the proposed 'fixed' SCHED_SPORADIC deal with admission control?]
> 
> But as it stands, this work would provide much more complete sporadic
> task support than the fixed SCHED_SPORADIC would.
> 
> 
> 
> -- 
> This message has been scanned for viruses and
> dangerous content by MailScanner, and is
> believed to be clean.
