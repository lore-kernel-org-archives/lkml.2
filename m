Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab1FEOGS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 10:06:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36078 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890Ab1FEOGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 10:06:17 -0400
Date: Sun, 5 Jun 2011 16:06:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arne Jansen <lists@die-jansens.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110605140602.GA29338@elte.hu>
References: <20110605081747.GA17920@elte.hu>
 <4DEB4FA7.3050400@die-jansens.de>
 <20110605095555.GA22058@elte.hu>
 <4DEB58D8.4000805@die-jansens.de>
 <20110605110132.GB23463@elte.hu>
 <20110605111933.GA24592@elte.hu>
 <20110605113627.GA25724@elte.hu>
 <4DEB6F3A.3000109@die-jansens.de>
 <20110605133958.GA27812@elte.hu>
 <4DEB8A93.30601@die-jansens.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEB8A93.30601@die-jansens.de>
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


* Arne Jansen <lists@die-jansens.de> wrote:

> On 05.06.2011 15:39, Ingo Molnar wrote:
> >
> >* Arne Jansen<lists@die-jansens.de>  wrote:
> >
> >>>>Warning: it's entirely untested.
> >>
> >>How is the output supposed to come through? shouldn't printk revert
> >>to early_printk instead of just returning?
> >
> >oh, right you are.
> >
> >Does the patch below work? It does early-printk within printk().
> 
> Too late, I already built my on early_vprintk ;)

heh :-)

Mind posting the patch? Your tested patch is infinitely more valuable 
than my not-even-build-tested patch ;-)

Thanks,

	Ingo
