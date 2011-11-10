Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934661Ab1KJN6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:58:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51532 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab1KJN6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:58:54 -0500
Date: Thu, 10 Nov 2011 14:57:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeff Garzik <jeff@garzik.org>
Subject: Re: linux-next: Tree for Oct 11 (ata/pata_of_platform.c)
Message-ID: <20111110135703.GA23609@elte.hu>
References: <20111011201127.455df266dcbffb1d621f8576@canb.auug.org.au>
 <4E94A920.40503@xenotime.net>
 <4E987829.3080104@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E987829.3080104@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Randy Dunlap <rdunlap@xenotime.net> wrote:

> On 10/11/2011 01:37 PM, Randy Dunlap wrote:
> > On 10/11/11 02:11, Stephen Rothwell wrote:
> >> Hi all,
> >>
> >> The linux-next tree is now available from
> >> git://github.com/sfrothwell/linux-next.git as a temporary measure while
> >> the kernel.org servers are unavailable.
> >>
> >> It may also turn up on git.kernel.org (depending on the mirroring).  The
> >> patch set is still absent, however.
> >>
> >> Changes since 20111007:
> >>
> >> Removed tree: ide (at the maintainer's request)
> > 
> > 
> > drivers/ata/pata_of_platform.c:55:13: error: 'NO_IRQ' undeclared (first use in this function)
> 
> 
> [adding Author: Anton]
> 
> Build error still present in linux-next of 20111014.

This build failure regression report was ignored twice and then 
pushed upstream and is still unfixed a month after the initial 
report. Upstream now fails to build on like 25% of x86 configs.

What's going on with this bug guys?

Thanks,

	Ingo
