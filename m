Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab0EOHdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 03:33:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51513 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab0EOHdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 03:33:08 -0400
Date: Sat, 15 May 2010 09:32:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai.lu@oracle.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 15/35] x86, lmb: Add lmb_reserve_area_overlap_ok()
Message-ID: <20100515073231.GB9877@elte.hu>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
 <1273796396-29649-16-git-send-email-yinghai@kernel.org>
 <1273804337.21352.396.camel@pasglop>
 <4BECF158.5070200@oracle.com>
 <1273825807.21352.601.camel@pasglop>
 <4BED7CE3.1020507@oracle.com>
 <1273876234.21352.639.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273876234.21352.639.camel@pasglop>
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


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Fri, 2010-05-14 at 09:40 -0700, Yinghai Lu wrote:
> > later, after this patchset. this patchset is hanging around too long
> > already.
> 
> That's where I strongly disagree with Ingo :-) 
> There's no such thing as a patch set hanging around 
> too long. Patches should go in when they are ready 
> and in good shape, not due to some kind of time 
> bomb, which results in tons of unfixable crap being 
> merged, which is very bad engineering.

The thing i disagreed with was that the patches were 
posted in March and there was no progress for a long 
time. That kind of situation only leads to patches 
being piled up unreasonably and results in Yinghai 
wasting time and effort.

But now there's real progress: you posted patches and 
Yinghai is posting patches and is reacting to your 
review feedback. As long there's steady progress (and 
not just the steady decay of entropy destroying 
already created value) i'm a happy camper.

Btw., it would be nice to ready the LMB core bits for 
upstream for 2.6.35 if there's agreement about them - 
that will make the subsequent x86 patches much easier 
to merge.

Thanks,

	Ingo
