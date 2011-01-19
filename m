Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab1ASXMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 18:12:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52769 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab1ASXMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 18:12:33 -0500
Date: Thu, 20 Jan 2011 00:11:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: percpu related boot crash on x86 (was: Linux 2.6.38-rc1)
Message-ID: <20110119231116.GA3896@elte.hu>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <20110119120200.GA1057@elte.hu>
 <1295441307.28776.15.camel@laptop>
 <AANLkTi=gxMkzO63RAWiuFt9vp57dvi4d=TaT=NmuvyY2@mail.gmail.com>
 <20110119131329.GB14096@mtj.dyndns.org>
 <20110119205353.GA14810@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119205353.GA14810@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Btw., based on Peter's suggestion i tried the limit-bumping hack below - but it 
> did not help, the crash still triggers on 5%-10% of all randconfig bootups.

I'm now running tests with MAXSMP forcibly disabled - and there are no crashes after 
69 randconfig iteration. Before it would crash within 10 iterations.

So it seems the MAXSMP sizing tests triggers a new percpu regression.

Thanks,

	Ingo
