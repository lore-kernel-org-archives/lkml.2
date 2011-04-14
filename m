Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab1DNJZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 05:25:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38607 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab1DNJZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 05:25:30 -0400
Date: Thu, 14 Apr 2011 11:25:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip tree with Linus' tree
Message-ID: <20110414092519.GA18329@elte.hu>
References: <20110414131440.fb8dc3ad.sfr@canb.auug.org.au>
 <1302771770.2388.131.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302771770.2388.131.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2011-04-14 at 13:14 +1000, Stephen Rothwell wrote:
> > 
> > Today's linux-next merge of the tip tree got a conflict in kernel/sched.c
> > between commit 6631e635c65d ("block: don't flush plugged IO on forced
> > preemtion scheduling") from Linus' tree and commits 098247b90a9e ("sched:
> > Provide p->on_rq") and a3380736e4b3 ("sched: Also serialize ttwu_local()
> > with p->pi_lock") from the tip tree.
> > 
> > I fixed them up (hopefully - see below) and can carry the fix as
> > necessary. 
> 
> It looks like Ingo accidentially published an older version of these patches 
> because I also got a UP build error from Tony yesterday.

It was intentionally published.

> A new series was merged this morning which should hopefully address both 
> problems.

Yes.

Thanks,

	Ingo
