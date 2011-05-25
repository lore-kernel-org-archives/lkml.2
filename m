Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab1EYHzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 03:55:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54237 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab1EYHza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 03:55:30 -0400
Date: Wed, 25 May 2011 09:55:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Milton Miller <miltonm@bga.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RFC 4/4] irq: allow a per-allocation upper limit when
 allocating irqs
Message-ID: <20110525075517.GC21552@elte.hu>
References: <generic-irq-changes@mdm.bga.com>
 <alloc-irq-range-v2@mdm.bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alloc-irq-range-v2@mdm.bga.com>
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


* Milton Miller <miltonm@bga.com> wrote:

> Allow the option to specify an upper limit to the irq numbers for
> each allocation.  The limit is non-inclusive, and 0 means no limit
> needed by caller.
> 
> Some irq chips can support a relative large and arbitrary range,
> but not infinite.  For example, they may use the linux irq number
> as the msi desciptor data, which for msi is 16 bits.
> 
> Since e7bcecb7b1 (genirq: Make nr_irqs runtime expandable), checking
> NR_IRQS or even nr_irqs is not sufficient to enforce such requirements
> when sparse irqs are configured.

Would be nice to add some more background info to the changelog, like what bad 
things happen if this change is not provided and what good things would happen 
if it is provided.

Thanks,

	Ingo
