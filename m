Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab1BCVju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:39:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39118 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301Ab1BCVjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:39:49 -0500
Date: Thu, 3 Feb 2011 22:39:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: Re: [patch] x86, mm: avoid stale tlb entries by clearing prev
 mm_cpumask after switching mm
Message-ID: <20110203213936.GA19673@elte.hu>
References: <1296677247.4418.103.camel@sbsiddha-MOBL3.sc.intel.com>
 <AANLkTi=P+aoY4GY32xa8D8gHbDP73QpPmzvKbB4VM7g2@mail.gmail.com>
 <AANLkTinvQatNF0ZJqmvuKYNq7oKXqfR5Ke1FuaSLFNEF@mail.gmail.com>
 <1296757637.4418.1482.camel@sbsiddha-MOBL3.sc.intel.com>
 <AANLkTimuSV273ksidN_vQ4o1rLr6D--9Q3dNnBiB13-K@mail.gmail.com>
 <1296761671.4418.1558.camel@sbsiddha-MOBL3.sc.intel.com>
 <AANLkTimjYAYPLf=QG22hFHm7yhABCQj7q=kOpB6HcB5e@mail.gmail.com>
 <1296764404.4418.1634.camel@sbsiddha-MOBL3.sc.intel.com>
 <20110203210616.GA17471@elte.hu>
 <AANLkTinSQ36nfVbRK3GnFmtUtPMLaBF58mO_1McA6HD8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinSQ36nfVbRK3GnFmtUtPMLaBF58mO_1McA6HD8@mail.gmail.com>
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

> On Thu, Feb 3, 2011 at 1:06 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Do you want to apply it or should I?
> 
> I already did (but I now amended it to have your ack and pushed it out).

Cool, thanks!

	Ingo
