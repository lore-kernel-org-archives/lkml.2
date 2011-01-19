Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab1ASWRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:17:45 -0500
Received: from www.tglx.de ([62.245.132.106]:43010 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab1ASWRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:17:43 -0500
Date: Wed, 19 Jan 2011 23:16:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: [patch 32/37] parisc: Use generic irq Kconfig
In-Reply-To: <1295474722.10978.43.camel@mulgrave.site>
Message-ID: <alpine.LFD.2.00.1101192314090.3211@localhost6.localdomain6>
References: <20110119205258.462759212@linutronix.de>  <20110119210840.424269590@linutronix.de> <1295474722.10978.43.camel@mulgrave.site>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jan 2011, James Bottomley wrote:

> On Wed, 2011-01-19 at 21:49 +0000, Thomas Gleixner wrote:
> > plain text document attachment (parisc-use-generic-irq-Kconfig.patch)
> > No functional change.
> 
> Not quite true ... you take out GENERIC_HARDIRQS but select
> HAVE_GENERIC_HARDIRQS ... is that right?

HAVE_GENERIC_HARDIRQS enables the Kconfig file in kernel/irq/
 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Kyle McMartin <kyle@mcmartin.ca>
> 
> Plus, it doesn't apply:
> 
> Hunk #1 FAILED at 12.
> Hunk #2 FAILED at 65.
> 2 out of 2 hunks FAILED -- saving rejects to file
> arch/parisc/Kconfig.rej
> 
> It looks like it was made before we did our generic irq conversion in
> the 2.6.36 merge window.

You meant 38 window :) Patch is against 38-rc1 but depends on [patch
24/37] genirq: Remove __do_IRQ in this very same series.

Thanks,

	tglx
