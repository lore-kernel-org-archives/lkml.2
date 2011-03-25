Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab1CYMlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 08:41:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37382 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab1CYMlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 08:41:36 -0400
Date: Fri, 25 Mar 2011 13:41:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86 APM: delete Linux kernel APM support
Message-ID: <20110325124124.GA31408@elte.hu>
References: <alpine.LFD.2.02.1103232321070.3848@x980>
 <20110324154505.934a56a0.sfr@canb.auug.org.au>
 <alpine.LFD.2.02.1103240336590.4529@x980>
 <alpine.LFD.2.02.1103240414450.4529@x980>
 <20110324083959.GE30812@elte.hu>
 <alpine.LFD.2.02.1103241929450.16085@x980>
 <20110325113048.GC29521@elte.hu>
 <20110325123815.GA29936@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110325123815.GA29936@elte.hu>
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
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > Okay, I can delay this way:
> > > 
> > > 2.6.39:
> > > 	feature-removal.txt targets 2.6.42 removal
> > > 	depend on CONFIG_EXPERT
> > > 
> > > 2.6.40, 2.6.41:
> > > 	WARN once on run-time access
> > > 
> > > 2.6.42:
> > > 	remove.
> > 
> > Regardless of removal, i'd suggest a "this code is not supported" kind of 
> > WARN() message to the APM code today, into .39 - to see whether it pops up 
> > anywhere - and mark it for -stable as well.
> > 
> > .42 removal might be too fast, considering the typical release schedule of 
> > Linux distributions. [...]
> 
> Anyway, i'd ack this schedule if you queued up the WARN() today with a -stable 
> tag, on the condition that if we get complaints about that message, we keep APM 
> support.

s/today/for .39

Thanks,

	Ingo
