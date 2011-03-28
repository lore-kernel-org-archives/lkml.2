Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1C1FTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 01:19:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37004 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab1C1FTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 01:19:18 -0400
Date: Mon, 28 Mar 2011 07:18:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86 APM: delete Linux kernel APM support
Message-ID: <20110328051841.GA1342@elte.hu>
References: <alpine.LFD.2.02.1103232321070.3848@x980>
 <20110324154505.934a56a0.sfr@canb.auug.org.au>
 <alpine.LFD.2.02.1103240336590.4529@x980>
 <alpine.LFD.2.02.1103240414450.4529@x980>
 <20110324083959.GE30812@elte.hu>
 <alpine.LFD.2.02.1103241929450.16085@x980>
 <20110325113048.GC29521@elte.hu>
 <alpine.LFD.2.02.1103260036300.28928@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1103260036300.28928@x980>
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


* Len Brown <lenb@kernel.org> wrote:

> > .42 removal might be too fast, considering the typical release schedule of 
> > Linux distributions. And i'm still doubting the removal itself: we are 
> > adding lots of special-purpose subarch drivers to arch/x86/ as we speak 
> > (the embedded mess coming to x86) - which drivers will be tomorrow's APM 
> > code. On what grounds do we treat APM support differently?
> >
> > Our general compatibility with old hardware is an *asset* that we should value.
> 
> My guess is that the customers have died off,

How do we know that? Users are on a bell curve, with a fat tail. If stuff just 
works - and that's not unexpected from relatively simple (and most likely to be 
used) APM functionality like APM-poweroff, why should they ever report 
problems?

Removing a driver based on lack of visible feedback is like removing 190,000 
apps from a 200,000 apps app store, on the (valid) observation that the top 
1000 apps receive 99% of the traffic and use so the remaining 1% are just a 
maintenance burden.

There's value in the concept of knowing that we do not do forced obscolescence 
in Linux and there's a value in a very broad "there's a driver for that" 
concept, just like there's value in a very broad "there's an app for that" 
concept.

> and so the code is no longer an asset, but a maintenance liability.
> 
> If there is a buzzing community of people running 2011
> linux kernels on their ancient laptops in APM mode,
> then the APM maintainer would probably know about them.

Not if most of them use APM-poweroff. I think i even had a desktop box (not a 
laptop) that supported APM suspend (or am i mistaken there, was APM suspend 
support only limited to laptops?).

Thanks,

	Ingo
