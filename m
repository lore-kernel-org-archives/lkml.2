Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab1EXTaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:30:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42767 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932649Ab1EXTaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:30:07 -0400
Date: Tue, 24 May 2011 21:29:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v5] x86: UV uv_tlb.c cleanup
Message-ID: <20110524192949.GH6561@elte.hu>
References: <E1QOrld-0003II-DP@eag09.americas.sgi.com>
 <20110524151910.GA23496@elte.hu>
 <BANLkTiknsRgnkM=pQhAzFDe_uCWG-Du7hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTiknsRgnkM=pQhAzFDe_uCWG-Du7hw@mail.gmail.com>
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


* Pekka Enberg <penberg@kernel.org> wrote:

> On Tue, May 24, 2011 at 6:19 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > Don't the kfree()s get changed - i.e. the patch has a side-effect?
> >
> > And yes, while this might be a kmem leak fix, it is a fix and a *SIDE EFFECT*
> > which i explicitly asked to be queued in a separate patch(es) from the large
> > cleanup patch ...
> >
> > The cleanup patch should be a cleanup of existing code - even if that code has
> > bugs. Nothing more. Bug fixes are for different patches.
> 
> There's also renames in the patch that make it pretty hard to review
> for correctness. Formatting changes are best done as separate patches.

Well, yeah, but there were so many cleanliness problems with that code that i 
think we are better off with having this big cleanup over and then start 
working with small, self-contained cleanups and improvements.

Thanks,

	Ingo
