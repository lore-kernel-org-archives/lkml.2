Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab0FPHc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 03:32:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40338 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab0FPHc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 03:32:57 -0400
Date: Wed, 16 Jun 2010 09:32:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@lst.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86-32: always use irq stacks
Message-ID: <20100616073240.GA12064@elte.hu>
References: <20100526110923.GA28414@lst.de>
 <20100616051629.GA26012@lst.de>
 <20100616055609.GC17936@elte.hu>
 <20100616062748.GA29543@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616062748.GA29543@lst.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1469]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@lst.de> wrote:

> On Wed, Jun 16, 2010 at 07:56:09AM +0200, Ingo Molnar wrote:
> > 
> > * Christoph Hellwig <hch@lst.de> wrote:
> > 
> > > ping?  This just came up again as a side-issue in the direct reclaim thread.  
> > > x86-32 really is the only one out there still having this compared to the 
> > > other common architetures like x86-64, powerpc and s390.
> > 
> > We should also make 8K stacks the default on 32-bit. I.e. remove all the 
> > Kconfig distinctions and make the stack model similar on 32-bit and 64-bit 
> > x86.
> 
> Sounds fine to me.  Do you want an additional patch for that or a respin
> to include it in one patch?

Two patches would be fine too - gives people something more finegrained to 
bisect to, should there be any problems.

Thanks,

	Ingo
