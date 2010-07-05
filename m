Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab0GEMqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 08:46:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37571 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab0GEMq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 08:46:29 -0400
Date: Mon, 5 Jul 2010 14:45:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ali Gholami Rudi <ali@rudi.ir>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, dfeng@redhat.com, x86@kernel.org,
       venki@google.com, tglx@linutronix.de, suresh.b.siddha@intel.com,
       mingo@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [regression] commit 6a4f3b52 causes invalid memtype
Message-ID: <20100705124549.GA2260@elte.hu>
References: <20100507075128@tarekhel>
 <4C319D61.5090002@redhat.com>
 <20100507092842@tarekhel>
 <4C31A7A0.1020800@redhat.com>
 <4c31ac7b.J+CU0Yt+zKZ9ho1fjKvu6Z1v@tarekhel>
 <20100705104035.GA28190@elte.hu>
 <20100507113814@tarekhel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507113814@tarekhel>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0563]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ali Gholami Rudi <ali@rudi.ir> wrote:

> Ingo Molnar <mingo@elte.hu> wrote:
> > > > >> commit 2463eb8b3093995e09a0d41b3d78ee0cf5fb4249
> > > > >> Author: Peter Zijlstra<peterz@infradead.org>
> > > > >> Date:   Sat May 29 15:31:43 2010 +0200
> > > > >>
> > > > >>       rbtree: Undo augmented trees performance damage
> > > > >
> > > > > Where can I get it?  I couldn't find it either in
> > > > > Linus' or x86 repo tip.
> > > > http://git.kernel.org/tip/2463eb8b3093995e09a0d41b3d78ee0cf5fb4249
> > > 
> > > It does fix it.
> > 
> > Hm, interesting. That's a pure performance fix - so why does it fix a 
> > regression?
> > 
> > Does Peter's augmented rbtrees improvements fix a bug too, as a side-effect? 
> > If yes then we need to accelerate that commit - right now it's aimed for 
> > v2.6.36.
> 
> Since the bug appears after commit 6a4f3b52, it seems to be
> related to the value of memtype->subtree_max_end.  Peter's
> patch seems to change the way memtype->subtree_max_end is
> updated, which seems to fix the problem too.

Ok - i've cherry-picked it over into x86/urgent and it should go to Linus in 
the next round of x86 fixes.

Thanks,

	Ingo
