Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab1CBScK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 13:32:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52046 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755579Ab1CBScI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 13:32:08 -0500
Date: Wed, 2 Mar 2011 19:32:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Reverting NUMA-affine page table allocation
Message-ID: <20110302183200.GF13693@elte.hu>
References: <20110226143730.GA26864@htj.dyndns.org>
 <AANLkTinW-nQV4tL-_PicOb-N6imv3gtWuG-J69-6VUQd@mail.gmail.com>
 <20110302161900.GP3319@htj.dyndns.org>
 <AANLkTi=SYRK+iKT-Zwuyv=e6dLqmoL4cUts2Xoyq-M=1@mail.gmail.com>
 <20110302170702.GS3319@htj.dyndns.org>
 <20110302180827.GA13693@elte.hu>
 <4D6E8874.6070000@zytor.com>
 <20110302181941.GD13693@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302181941.GD13693@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > On 03/02/2011 10:08 AM, Ingo Molnar wrote:
> > > 
> > >> To me, it seems complicated for not good enough reasons.  I'll defer
> > >> the decision to x86 maintainers.  Ingo, hpa, Thomas, what do you guys
> > >> think?
> > > 
> > > Would be nice to see an actual patch that does the revert.
> > > 
> > 
> > I also would like to point out that we are at -rc7.  The time to test
> > new things is quickly running out, so a more conservative option for
> > this upcoming merge window is starting to look good.
> 
> Hm, i thought the revert was for tip:x86/mm, not x86/urgent. [...]

On a second reading you suggested the same, so please ignore my mail! :-)

Thanks,

	Ingo
