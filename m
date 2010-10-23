Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab0JWOPy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 10:15:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47892 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080Ab0JWOPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 10:15:53 -0400
Date: Sat, 23 Oct 2010 16:15:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86/trampoline for 2.6.37
Message-ID: <20101023141534.GC7768@elte.hu>
References: <201010230117.o9N1H2Mk032101@hera.kernel.org>
 <AANLkTimOHBw19TuouqNsEaBcZnfU5kaBoB0Fm+QhRz4h@mail.gmail.com>
 <20101023092429.GA910@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101023092429.GA910@liondog.tnic>
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


* Borislav Petkov <bp@alien8.de> wrote:

> On Sat, Oct 23, 2010 at 11:17:42AM +0530, Jaswinder Singh Rajput wrote:
> > > +#ifdef CONFIG_X86_32
> > > +#include <asm/pgtable.h>
> > > +#include <asm/pgtable_32.h>
> > > +#endif
> > > +
> > 
> > pgtable.h will take care of pgtable_32.h, why you are doing this ?
> 
> Frankly, I don't remember. Here's an updated patch.
> 
> Linus, you could apply the following one instead of pulling from the branch, if 
> hpa is ok with it. It is against your tree of the moment v2.6.36-1431-gf5d9d24.

Please send a delta patch and we can do any trivial changes via the usual channels. 
The tree hpa sent to Linus is tested and this is tricky code.

Thanks,

	Ingo
