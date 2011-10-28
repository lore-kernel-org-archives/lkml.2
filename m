Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab1J1OeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 10:34:19 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21430 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab1J1OeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 10:34:18 -0400
Date: Fri, 28 Oct 2011 10:33:36 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, hpa@zytor.com, jeremy.fitzhardinge@citrix.com,
        mingo@redhat.com, stable@kernel.org, tglx@linutronix.de,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Not really merged? Re: [merged]
 x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode.patch
 removed from -mm tree
Message-ID: <20111028143336.GA7016@phenom.dumpdata.com>
References: <201110141951.p9EJpn3A006989@hpaq5.eem.corp.google.com>
 <20111025182450.GA9843@phenom.dumpdata.com>
 <20111027155329.0adc1358.akpm@linux-foundation.org>
 <20111028070838.GG12995@elte.hu>
 <20111028003935.a75d16b6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111028003935.a75d16b6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4EAABD4B.0177,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > But IMO it's at least as important to figure out what went wrong. I 
> > somehow doubt it that you spuriously dropped it - that someone else 
> > messes up has a far higher likelihood.
> 
> My drop was legitimate. 
> 
> Here's the commit from the Oct 14 linux-next:
> 
> 
> commit ab67482036cee590753dd42b7f66aada97e6dcde
> Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> AuthorDate: Fri Sep 23 17:02:29 2011 -0400
> Commit:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> CommitDate: Mon Sep 26 09:12:37 2011 -0400
.. snip..
> 
> I'm not sure what to make of that.  The signoffs imply that Konrad is
> running his own git tree, but I don't think he is.  Or someone (Jeremy
> or Rusty I think) merged it but didn't add a signoff.

Hey Andrew,

I am running my own tree (git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git)

> Note that the patch was merged using its old name "x86/paravirt:
> Partially revert "remove lazy mode in interrupts"".  The patch got
> renamed to "x86/paravirt: PTE updates in k(un)map_atomic need to be
> synchronous, regardless of lazy_mmu mode" and perhaps this prompted
> someone to drop the old-named patch then lose the new-named one.

I am at loss as why I had that patch in my tree. I *might* have merged
in my #linux-next to compile/build/run-time test and then pushed that
tree. But I can't recall exactly why I would have done that (the push).

The fault is with me and I am sorry for making you (and Ingo) spend the
whole night digging through linux-next git history to figure this out.
