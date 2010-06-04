Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab0FDIfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 04:35:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41427 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312Ab0FDIfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 04:35:19 -0400
Date: Fri, 4 Jun 2010 10:34:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arve Hj?nnev?g <arve@android.com>
Cc: tytso@mit.edu, Brian Swetland <swetland@google.com>,
       Neil Brown <neilb@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend blockers & Android integration
Message-ID: <20100604083423.GD15181@elte.hu>
References: <20100603193045.GA7188@elte.hu>
 <20100603231153.GA11302@elte.hu>
 <20100603232302.GA16184@elte.hu>
 <AANLkTikZP3bmckpfb_jUdG7qZO5W9DgpZ79ugtSZaEpt@mail.gmail.com>
 <20100604071354.GA14451@elte.hu>
 <AANLkTimH4ihf3QqtKFpfGXRKtO55PrUuff9JYtaEBG44@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimH4ihf3QqtKFpfGXRKtO55PrUuff9JYtaEBG44@mail.gmail.com>
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


* Arve Hj?nnev?g <arve@android.com> wrote:

> > [...]
> >
> > Why do you need to track input wakeups? It's rather fragile and rather 
> > unnecessary [...]
> 
> Because we have keys that should always turn the screen on, but the problem 
> is not specific to input events. If we enabled a wakeup event it usually 
> means we need this event to always work, not just when the system is fully 
> awake or fully suspended.

Hm, i cannot follow that generic claim. Could you please point out the problem 
to me via a specific example? Which task does what, what undesirable thing 
happens where, etc.

Thanks,

	Ingo
