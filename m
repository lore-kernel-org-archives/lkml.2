Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1ECUvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:51:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39351 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150Ab1ECUvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:51:08 -0400
Date: Tue, 3 May 2011 22:50:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110503205051.GA28647@elte.hu>
References: <web-516671337@zbackend1.aha.ru>
 <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com>
 <web-516990066@zbackend1.aha.ru>
 <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com>
 <20110503190822.GA20520@elte.hu>
 <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <4DC06386.8090206@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC06386.8090206@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 05/03/2011 01:17 PM, Linus Torvalds wrote:
> > 
> > That said, I don't really see why ELAN would be so special.
> > 
> 
> ELAN used to have a nonstandard A20 enabling sequence, until someone
> found out that changes to the mainline sequence had made ELAN work as a
> side effect.
> 
> At this point, it's just a CPU selection thing, so it makes very little
> sense.

the ELAN .config option influences the following details:

 - sets X86_L1_CACHE_SHIFT to 4 (16 bytes) instead of the typical 6 (64 bytes)
 - sets X86_ALIGNMENT_16
 - sets the -march=i486 compiler flag

So in terms of the kernel image it seems to be mostly equivalent to selecting 
i486 from the CPU menu - except the X86_ALIGNMENT_16 detail (which does not 
seem to do anything substantive, AFAICS).

Thanks,

	Ingo
