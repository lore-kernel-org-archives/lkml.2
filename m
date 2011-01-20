Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab1ATMPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 07:15:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55350 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430Ab1ATMPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 07:15:13 -0500
Date: Thu, 20 Jan 2011 13:14:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH -v10 0/4] Lock-less list
Message-ID: <20110120121455.GA7680@elte.hu>
References: <1295245019-7816-1-git-send-email-ying.huang@intel.com>
 <20110119135546.bb7e8f62.akpm@linux-foundation.org>
 <1295484358.15213.25.camel@yhuang-dev>
 <20110119165247.cca2f434.akpm@linux-foundation.org>
 <1295520247.28776.152.camel@laptop>
 <AANLkTimR6xd1PxCP6jmuNwFkANrGPdTf2wpiGsBXGpKx@mail.gmail.com>
 <1295522876.28776.158.camel@laptop>
 <AANLkTin3_NuGG_E0Juy7=1Q7PcMJ6id1ZU-Gngfp_=dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin3_NuGG_E0Juy7=1Q7PcMJ6id1ZU-Gngfp_=dg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* huang ying <huang.ying.caritas@gmail.com> wrote:

> > But will all that stuff be accepted? Please stop sending infrastructure bits and 
> > focus on your larger RAS picture, once you have consensus on that from all 
> > parties involved, then, and only then, does it make sense to submit everything, 
> > including infrastructure.
> 
> I am not sending hardware error reporting infrastructure.  As far as I know, Linus 
> and Andrew suggest to use printk for hardware error reporting.  And now, I just 
> try to write APEI driver and reporting hardware error with printk.  Is it 
> acceptable?  Do you have some other idea about hardware error reporting?

Erm, how could you possible have missed the perf based RAS daemon work of Boris, 
which we've pointed out about half a dozen times already?

It's somewhat annoying that you simply ignore repeated feedback and feign ignorance. 
Reminds me of someone :-)

	Ingo
