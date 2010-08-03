Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab0HCF3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 01:29:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44130 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab0HCF33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 01:29:29 -0400
Date: Tue, 3 Aug 2010 07:29:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: build failure after merge of the final tree (tip
 tree related)
Message-ID: <20100803052911.GA25362@elte.hu>
References: <20100803022310.bec3ba79.sfr@canb.auug.org.au>
 <20100802162810.GB4755@flint.arm.linux.org.uk>
 <1280799724.1902.84.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280799724.1902.84.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0802]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> > Please, no, don't break the memblock code now.  I'm not reworking the
> > ARM implementation just as the merge window has opened - especially
> > as the ARM implementation has now been pulled into other people's
> > trees.
> > 
> > If there's changes to memblock which haven't been in linux-next (which,
> > as this is a new failure, that is most definitely the case), then they
> > shouldn't be going into this merge window.
> 
> I'm happy to wait and sit on the memblock churn until after ARM's in.
> 
> I can then fixup my patches.

Ok, i've zapped it all from -tip.

Thanks,

	Ingo
