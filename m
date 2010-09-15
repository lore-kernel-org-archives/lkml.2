Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab0IOIRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 04:17:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55116 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab0IOIRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 04:17:01 -0400
Date: Wed, 15 Sep 2010 10:16:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Cross Memory Attach
Message-ID: <20100915081653.GA16406@elte.hu>
References: <20100915104855.41de3ebf@lilo>
 <20100915080235.GA13152@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100915080235.GA13152@elte.hu>
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


> > NPB:
> > ====
> > BT - 12% improvement
> > FT - 15% improvement
> > IS - 30% improvement
> > SP - 34% improvement
> > 
> > IMB:
> > ===
> > 		
> > Ping Pong - ~30% improvement
> > Ping Ping - ~120% improvement
> > SendRecv - ~100% improvement
> > Exchange - ~150% improvement
> > Gather(v) - ~20% improvement
> > Scatter(v) - ~20% improvement
> > AlltoAll(v) - 30-50% improvement

btw., how does OpenMPI signal the target tasks that something happened 
to their address space - is there some pipe/socket side-channel, or 
perhaps purely based on flags in the modified memory areas, which are 
polled?

	Ingo
