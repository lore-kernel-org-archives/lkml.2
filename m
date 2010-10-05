Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab0JEJMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 05:12:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54532 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932314Ab0JEJMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 05:12:43 -0400
Date: Tue, 5 Oct 2010 11:12:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the lost-spurious-irq tree with the
 tip tree
Message-ID: <20101005091223.GA16005@elte.hu>
References: <20101005141334.6a0f15fd.sfr@canb.auug.org.au>
 <4CAABC0E.3030700@kernel.org>
 <20101005063227.GB12267@elte.hu>
 <20101005174524.b62d14a1.sfr@canb.auug.org.au>
 <20101005070123.GF12267@elte.hu>
 <20101005193803.e805b3eb.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101005193803.e805b3eb.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Ingo,
> 
> On Tue, 5 Oct 2010 09:01:23 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
> > Fortunately there's a really simple solution: wait for an explicit 
> > reply from a maintainer before adding a new-feature tree. (Solicite 
> > again via a To: email if the Cc: went unanswered by the 
> > maintainers.)
> 
> Sure we can try that.

Thanks.

> > Could you please start using that method for all subsystems i 
> > co-maintain?
> 
> So, to be clear, from the MAINTAINERS file that would be LOCKDEP AND 
> LOCKSTAT, PERFORMANCE EVENTS SUBSYSTEM, SCHEDULER, TRACING, and X86 
> ARCHITECTURE. [...]

Yep - those are the main ones.

( You might want to apply the process generally as well - it's rather 
  rare that trees parallel to maintainer trees get added to linux-next 
  and IMO it pays to make sure the maintainers are actively fine with 
  such additions.

  A Cc: to a mail with no patch content is easy to miss and it's useful
  to solicit a 'yeah, sure it's fine' mail from a maintainer - just like 
  we solicit Acked-by's from maintainers for much smaller matters than 
  full trees (individual patches).

  This would further ensure that linux-next is indeed a stable
  approximation of the 'next Linux' as intended by maintainers.
  To me this looks like a pretty obvious and useful thing to do. )

Thanks,

	Ingo
