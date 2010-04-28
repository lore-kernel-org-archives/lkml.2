Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab0D1W3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 18:29:37 -0400
Received: from www.tglx.de ([62.245.132.106]:57518 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756337Ab0D1W3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 18:29:36 -0400
Date: Thu, 29 Apr 2010 00:28:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Guillaume Knispel <gknispel@proformatique.com>
cc: linux-kernel@vger.kernel.org, Linuxppc-dev@lists.ozlabs.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, Ingo Molnar <mingo@elte.hu>,
       Lars-Peter Clausen <lars@metafoo.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Buesch <mb@bu3sch.de>, Peter Zijlstra <peterz@infradead.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/2] genirq: reliably replay pending edge-triggered irq
In-Reply-To: <20100428235657.7120edd9.gknispel@proformatique.com>
Message-ID: <alpine.LFD.2.00.1004290027090.2951@localhost.localdomain>
References: <1271941798-9659-1-git-send-email-gknispel@proformatique.com> <1271941798-9659-2-git-send-email-gknispel@proformatique.com> <alpine.LFD.2.00.1004271537130.2951@localhost.localdomain> <20100428235657.7120edd9.gknispel@proformatique.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010, Guillaume Knispel wrote:

> On Tue, 27 Apr 2010 15:42:11 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Thu, 22 Apr 2010, Guillaume Knispel wrote:
> [snip] 
> > > acked and masked at controller level and IRQ_PENDING is set.
> > > ---
> > >  arch/arm/Kconfig                                   |    4 ----
> > >  arch/arm/configs/acs5k_defconfig                   |    1 -
> > >  arch/arm/configs/acs5k_tiny_defconfig              |    1 -
> > 
> >    Changing the defconfigs should be a separate patch and I'm not
> >    going to push such a thing through the genirq tree. The stale
> >    entries do not hurt.
> 
> Ok
> In this separate patch, to I put "genirq" in the title?
> Do I put it in the same series?

Just keep them out for now and send them to the arch maintainers once
the change hits linus tree.

Thanks,

	tglx
