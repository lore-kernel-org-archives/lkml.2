Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab1BJVSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:18:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33346 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab1BJVSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:18:52 -0500
Date: Thu, 10 Feb 2011 22:18:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        anton@samba.org, Mike Travis <travis@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PULL] cpumask offstack finalization
Message-ID: <20110210211818.GA19463@elte.hu>
References: <201102091608.59448.rusty@rustcorp.com.au>
 <20110210124416.GE26094@elte.hu>
 <AANLkTi=zr5bZTankxU3oysM_bP=ty1Bze7K8BQ75yMBL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=zr5bZTankxU3oysM_bP=ty1Bze7K8BQ75yMBL@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Feb 10, 2011 at 4:44 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Hm, could we get rid of the obsolete percpu APIs once and for all? The fact that 
> > they are still around cause the leakage into new code to begin with.
> 
> Yes please.
> 
> And please don't expect it to be merged until the 39 merge window unless this also 
> fixes some serious bugs (I assume - without having looked at the patch - that none 
> of these are actually on-stack and relevant for any thousand+ cpu machines?)

Yeah, i considered it strictly .39 material.

Thanks,

	Ingo
