Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524Ab1EWT0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:26:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38146 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932649Ab1EWT0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:26:34 -0400
Date: Mon, 23 May 2011 21:26:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH -next] x86: apic_flat_64.c needs module.h
Message-ID: <20110523192623.GA6194@elte.hu>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
 <20110523104300.dd532a99.randy.dunlap@oracle.com>
 <4DDA9EAB.40304@gmail.com>
 <4DDAA2C0.7080108@gmail.com>
 <4DDAA384.2000203@oracle.com>
 <20110523191043.GB23629@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523191043.GB23629@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > >>>  arch/x86/kernel/apic/apic_flat_64.c |    1 +
> > >>>  1 file changed, 1 insertion(+)
> > >>>
> > >>> --- linux-next-20110523.orig/arch/x86/kernel/apic/apic_flat_64.c
> > >>> +++ linux-next-20110523/arch/x86/kernel/apic/apic_flat_64.c
> > >>> @@ -16,6 +16,7 @@
> > >>>  #include <linux/ctype.h>
> > >>>  #include <linux/init.h>
> > >>>  #include <linux/hardirq.h>
> > >>> +#include <linux/module.h>
> > >>>  #include <asm/smp.h>
> > >>>  #include <asm/apic.h>
> > >>>  #include <asm/ipi.h>
> > >>
> > >> Thanks Randy! For some reason I didn't hit this problem while
> > >> were compiling the kernel and testing it (I usually do not use
> > >> modules though).
> > >>
> > >> I've CC'ed Ingo and Suresh.
> > >>
> > > 
> > > Randy, while adding module.h here is correct I fail to see why I didn't
> > > hit this problem before, could you please post your config?
> > 
> > Certainly, it's attached.  It's a randconfig file.
> > I saw this build error on roughly 5 out of 15 randconfig builds.
> > 
> > CONFIG_SMP is disabled...
> 
> Your config builds just fine here, using latest -tip:

oh, stupid me, it's a warning, not a build failure.

Applied your fix, thanks Randy!

	Ingo
