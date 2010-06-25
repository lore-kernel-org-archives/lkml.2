Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab0FYVm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 17:42:29 -0400
Received: from www.tglx.de ([62.245.132.106]:36489 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab0FYVm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 17:42:28 -0400
Date: Fri, 25 Jun 2010 23:42:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Metcalf <cmetcalf@tilera.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: Enable more sophisticated IRQ model for 32-bit
 chips.
In-Reply-To: <4C25206D.6070305@tilera.com>
Message-ID: <alpine.LFD.2.00.1006252340060.18683@localhost.localdomain>
References: <201006252110.o5PLAovH010769@farm-0002.internal.tilera.com> <alpine.LFD.2.00.1006252320430.18683@localhost.localdomain> <4C25206D.6070305@tilera.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jun 2010, Chris Metcalf wrote:
> On 6/25/2010 5:22 PM, Thomas Gleixner wrote:
> > [...]
> > can you please cc me on irq related changes ? Also I'd prefer a combo
> > patch of the irq code which lets me see the full story w/o going to
> > pull another git tree from somewhere.
> 
> Sure, I'll cc you going forward.
> 
> What kind of combo patch did you have in mind?  Do you just want copies
> of the arch/tile files relevant to irqs?  I've attached irq.h and irq.c
> to this email; the rest (e.g. smp.c) is pretty minimal and probably best
> viewed in the diff context anyway.
> 
> I figured since the first round of tile-architecture changes has been
> signed off on and is in linux-next, I should treat that as a baseline
> when sending additional patches to LKML going forward.  Maybe I'm
> confused :-)

No, _I_ did not notice that the base stuff is in -next already :)
 
> Thanks in advance for your review and any patch-process clarification
> you can offer.

I have a look at the patches tomorrow when my brain is more awake.

Thanks,

	tglx
 
