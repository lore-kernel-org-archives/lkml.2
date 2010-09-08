Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab0IHQDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 12:03:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55931 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892Ab0IHQDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 12:03:39 -0400
Date: Wed, 8 Sep 2010 18:03:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] Preparatory patch for semaphore cleanup
Message-ID: <20100908160326.GA18932@elte.hu>
References: <alpine.LFD.2.00.1009081507250.2477@localhost6.localdomain6>
 <AANLkTikYEjV8ikkPsfJ0d7WsikWHJ0n74u9uDS4uGHC+@mail.gmail.com>
 <1283957961.23762.28.camel@laptop>
 <20100908155604.GA18064@elte.hu>
 <1283961504.23762.34.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283961504.23762.34.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0057]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2010-09-08 at 17:56 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Wed, 2010-09-08 at 07:54 -0700, Linus Torvalds wrote:
> > > > On Wed, Sep 8, 2010 at 6:11 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > > > >
> > > > > This patch just provides the DEFINE_SEMAPHORE macro which is required
> > > > > for the various subsystem cleanups I sent out, so we can finally get
> > > > > rid of init_MUTEX[_LOCKED] in 2.6.37.
> > > > 
> > > > Why is it called DEFINE_SEMAPHORE(), when two lines later the we have
> > > > DECLARE_MUTEX()?
> > > > 
> > > > IOW, the whole DEFINE vs DECLARE thing seems confused. I'm not saying
> > > > one is better than the other (maybe "define" is), but the mixing of
> > > > names is worse than either, I feel..
> > > 
> > > The rest of the series, that Thomas didn't include in this pull, removes
> > > all the DECLARE_MUTEX() users. So its temporary awkward-ness.
> > 
> > and DEFINE_MUTEX() is needed upstream so that we can spread those 
> 
> s/DEFINE_MUTEX/DEFINE_SEMAPHORE/

Heh, i was demonstrating Linus's point ;-)

Thanks,

	Ingo
