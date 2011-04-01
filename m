Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab1DAHpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 03:45:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40516 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060Ab1DAHpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 03:45:43 -0400
Date: Fri, 1 Apr 2011 09:45:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Brown <davidb@codeaurora.org>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, david@lang.hm,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110401074519.GC7594@elte.hu>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
 <20110331080634.GA18022@elte.hu>
 <20110331083044.GB14323@n2100.arm.linux.org.uk>
 <alpine.DEB.2.00.1103310855450.29543@asgard.lang.hm>
 <20110331164539.GB19452@n2100.arm.linux.org.uk>
 <AANLkTi=tyifvJU-hhdd7gT74GMctrCbQBdUAoEaRXOCy@mail.gmail.com>
 <alpine.LFD.2.00.1103311429590.28032@xanadu.home>
 <AANLkTi=kbozPcWEk9wVZb7emSWx48BJQS=7Uzaya9Lor@mail.gmail.com>
 <alpine.LFD.2.00.1103311649450.28032@xanadu.home>
 <8ya39m2mv65.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ya39m2mv65.fsf@huya.qualcomm.com>
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


* David Brown <davidb@codeaurora.org> wrote:

> When we push back, there is a good chance they just won't bother, not because 
> they don't want to do it, but because it doesn't fit a schedule, and there is 
> already something else for them to work on.
> 
> So what's the right answer here. [...]

IMO the right answer is what Linus and Thomas outlined:

   1) provide a small number of clean examples and clean abstractions
   2) to not pull new crap from that point on
   3) do this gradually but consistently

I.e. make all your requirements technical and actionable - avoid sweeping, 
impossible to meet requirements. Do not require people to clean up all of the 
existing mess straight away (they cannot realistically do it), do not summarily 
block the flow of patches, but be firm about drawing a line in the sand and be 
firm about not introducing new mess in a gradually growing list of well-chosen 
areas of focus.

Rinse, repeat.

If companies do not 'bother to push upstream', then management will eventually 
notice negative economic consequences:

 - Higher short-term production costs: upstream feedback/review/testing
   improves the product, so the lack of upstream feedback/review/testing
   increases the production costs of the product.

 - Higher long-term production costs: gradually slower SoC development due to a 
   morass of out-of-tree hacks that werent pushed upstream causing gradually 
   higher development costs. This means higher payroll costs and longer time to
   market - in which time more flexible competitors can beat you.

 - Brain drain: developers like to show their good work upstream as well, not
   just in some ship-and-forget out-of-tree kernel. Good developers will
   gravitate towards SoC companies that encourage them to work upstream.
   No matter how good of a business idea a company has if there's no good 
   developers.

 - Less revenue: a product can not possibly be more appealing to SoC customers
   if the upstream Linux kernel does not support it. As ARM moves up the food 
   chain towards more complex, higher profit margin products longer term 
   thinking gains foothold gradually.

 - Competitive disadvantages: most SoC competitors push their changes upstream,
   so they get free development assistance, they get free exposure, they get 
   free PR and they get opportunities. Not pushing upstream is a lost 
   opportunity.

All of these effects translate into real $$$$$$$ and affect the bottom line 
very directly, both short and long term. These costs also increase with time so 
they are not fixed.

If management does not actively encourage upstream-quality changes then 
management will have to justify why they exposed the company to these extra 
costs, complications and risks - just to save on the relatively minor (and 
fixed) cost of working with upstream.

If despite all that management still believes (rightly or wrongly) that it's 
cheaper for the company to do low quality throw-away code and does not care 
about any of the short and long-term costs listed above then this really means 
that they really do not care about you or about the upstream kernel - so they 
do not exist as far as the upstream kernel is concerned.

Why should you then reward them with pulling crap and why should you be willing 
to invest future maintenance overhead into their "we do not care about you" 
solution?

Working with upstream is a quid pro quo with plenty of advantages on both 
sides, which gives maintainers a heck of a leverage to push back on crap while 
still having all the incentives in the world to help produce a high quality 
kernel.

Thanks,

	Ingo
