Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab1J1HKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 03:10:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42113 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab1J1HKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 03:10:22 -0400
Date: Fri, 28 Oct 2011 09:08:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, hpa@zytor.com,
        jeremy.fitzhardinge@citrix.com, mingo@redhat.com, stable@kernel.org,
        tglx@linutronix.de
Subject: Re: Not really merged? Re: [merged]
 x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode.patch
 removed from -mm tree
Message-ID: <20111028070838.GG12995@elte.hu>
References: <201110141951.p9EJpn3A006989@hpaq5.eem.corp.google.com>
 <20111025182450.GA9843@phenom.dumpdata.com>
 <20111027155329.0adc1358.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111027155329.0adc1358.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 25 Oct 2011 14:24:50 -0400
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > On Fri, Oct 14, 2011 at 12:51:48PM -0700, akpm@google.com wrote:
> > > 
> > > The patch titled
> > >      Subject: x86/paravirt: PTE updates in k(un)map_atomic need to be synchronous, regardless of lazy_mmu mode
> > > has been removed from the -mm tree.  Its filename was
> > >      x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode.patch
> > > 
> > > This patch was dropped because it was merged into mainline or a subsystem tree
> > 
> > Hey Andrew,
> > 
> > I am actually not seeing this in mainline? Was it accidently dropped out of your tree?
> 
> hm, well spotted.  I'm not sure what happened here - possibly the 
> patch was merged into an x86 tree (and hence linux-next) but later 
> got lost. Or possibly not, and I just screwed up.

No, a patch with the -i 'paravirt.*lazy' pattern never touched -tip, 
even temporarily.

Could it be that someone else (say the Xen guys) picked it up, it 
went into linux-next, you thought it's applied - but then they 
dropped it?

Do we have a full log of all linux-next patches?

> Either way, it's a pretty important patch - we marked it for 
> -stable backporting.

Agreed.

But IMO it's at least as important to figure out what went wrong. I 
somehow doubt it that you spuriously dropped it - that someone else 
messes up has a far higher likelihood.

> > If that is the case I can convience you to put it back in or can 
> > I drive it to Linus with your Ack-ed by?
> 
> I resurrected my copy and shall send it along to the x86 guys soon.

Thanks,

	Ingo
