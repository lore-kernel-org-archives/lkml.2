Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab0CaVlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:41:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60417 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932625Ab0CaVlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:41:03 -0400
Date: Wed, 31 Mar 2010 23:40:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>, James Morris <jmorris@namei.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, airlied@linux.ie,
       Thomas Gleixner <tglx@linutronix.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
Message-ID: <20100331214047.GA5353@elte.hu>
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org>
 <4BB2EB1B.8090303@zytor.com>
 <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org>
 <20100331185916.GA12306@elte.hu>
 <v2m21d7e9971003311357ga4626e41h535ae733933fdc84@mail.gmail.com>
 <alpine.LFD.2.00.1003311401480.3707@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003311401480.3707@i5.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 1 Apr 2010, Dave Airlie wrote:
> >
> > A default y config option causing regressions still at rc3? [...]
> >
> > [...] and you guys keep going? This is the sort of shit Linus would flame 
> > me for a day or two for,
> > 
> > Can we get some f'ing consistency here?
> 
> Yeah. I think we need to remove the crap.
>
> I thought the problems were known, and fixed in -rc3. Clearly they weren't.

Yeah.

It would still be nice to get the before/after bootlogs, because we'd like to 
map out any remaining bugs.

> And by now it's not about changing the default any more - by now it's about 
> removing the known-crap code.

Ok, we can certainly do that too.

Should we scrap the whole x86 bootmem conversion to begin with? I'm not sure 
there's any fundamentally less risky way to it so if we try this again in .35 
we might run into similar regressions and i'd like to avoid that. I wouldnt 
mind not having to do that at all, it's been a lot of pain to pull it off and 
the lmb conversion looks even more intrusive.

Thanks,

	Ingo
