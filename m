Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab1J1OLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 10:11:20 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:44030 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab1J1OLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 10:11:19 -0400
Date: Fri, 28 Oct 2011 09:59:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, hpa@zytor.com, jeremy.fitzhardinge@citrix.com,
        mingo@redhat.com, stable@kernel.org, tglx@linutronix.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Xen tree maintenance] Re: Not really merged? Re: [merged]
 x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode.patch
 removed from -mm tree
Message-ID: <20111028135926.GB6509@phenom.dumpdata.com>
References: <201110141951.p9EJpn3A006989@hpaq5.eem.corp.google.com>
 <20111025182450.GA9843@phenom.dumpdata.com>
 <20111027155329.0adc1358.akpm@linux-foundation.org>
 <20111028070838.GG12995@elte.hu>
 <20111028003935.a75d16b6.akpm@linux-foundation.org>
 <20111028074810.GB27593@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111028074810.GB27593@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4EAAB7BC.0166,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > commit ab67482036cee590753dd42b7f66aada97e6dcde
> > Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > AuthorDate: Fri Sep 23 17:02:29 2011 -0400
> > Commit:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > CommitDate: Mon Sep 26 09:12:37 2011 -0400

Aha! And I am not sure why I put that in my #linux-next branch. That
is not good - thanks for identifying the cause of that patch being
dropped, and I am sorry for pushing it there without getting the
proper Acks.

> 
> ARGH!
> 
> Konrad, STOP THIS CRAP!
> 
> This is the Nth time you have interefered with the x86 tree's 
> workflow - and now you have caused patch loss in -mm.
> 
> I'll have to insist on the Xen tree being merged via the x86 tree 
> again, this clearly does not work, your maintenance practices are 
> VERY incompetent and you are not learning.
> 
> The rule is very simple: don't EVER push anything arch/x86/ into 
> linux-next that is outside the arch/x86/xen/ and 
> arch/x86/include/asm/xen/ patterns, without very clear acks from the 
> x86 maintainers and a binding promise to carry that patch upstream!

Of course.

If you have some time, can you tell me what other times this has
caused trouble? I remember Jeremy did a mistake some time ago
(so patch with a very very old time date) that screwed up something.

And .... oh, the compile time one that Randy found and it did not get
fixed for some very emberassingly long time. If I remember right that was
in Jeremy's tree (xen) - not mine (xen-two):
http://marc.info/?i=20110804193534.GB12729@elte.hu

We do have _two_ Xen trees (xen and xen-two) - which is not making things
easier to figure out who is at fault for what.

You would not have a good overview of maintainer practices so that both
me and Jeremy can refresh our memory of what to do and especially
what _not_ to do?
