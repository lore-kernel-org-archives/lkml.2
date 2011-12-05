Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab1LEP6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 10:58:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37671 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411Ab1LEP6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 10:58:39 -0500
Date: Mon, 5 Dec 2011 16:56:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefan Bader <stefan.bader@canonical.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, hpa@zytor.com,
        jeremy.fitzhardinge@citrix.com, mingo@redhat.com, stable@kernel.org,
        tglx@linutronix.de, Stephen Rothwell <sfr@canb.auug.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Not really merged? Re: [merged]
 x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode.patch
 removed from -mm tree
Message-ID: <20111205155647.GG28866@elte.hu>
References: <201110141951.p9EJpn3A006989@hpaq5.eem.corp.google.com>
 <20111025182450.GA9843@phenom.dumpdata.com>
 <20111027155329.0adc1358.akpm@linux-foundation.org>
 <20111028070838.GG12995@elte.hu>
 <20111028003935.a75d16b6.akpm@linux-foundation.org>
 <4ED60D59.6080308@canonical.com>
 <20111130114128.ad9c79be.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111130114128.ad9c79be.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 30 Nov 2011 12:02:49 +0100 Stefan Bader <stefan.bader@canonical.com> wrote:
> 
> > So, as of today, this seems to be back on the master branch of linux-next (I
> > guess from Andrew putting it back, but I am never sure with linux-next). But I
> > am not sure how/when this would go into Linus tree. I assume without any
> > specific action maybe merge window for 3.3...
> > We got some positive feedback on it from users running into the problem. So it
> > seems like a valuable change. From the discusions so far I take that technically
> > the change did not trigger resistance. For that reason I wanted to ask whether
> > there is a chance that this looks important enough to be pushed before the next
> > merge window...
> 
> I sent this patch to the x86 maintainers two weeks ago.  It 
> was ignored, as were the other 11 patches I sent.  Later I 
> will resend them all.  If they are again ignored I will later 
> send them yet again, and so on.

they are still sitting in my mbox - working down the backlog 
now.

Thanks,

	Ingo
