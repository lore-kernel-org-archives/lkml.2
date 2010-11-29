Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab0K2SDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:03:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50130 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab0K2SDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:03:54 -0500
Date: Mon, 29 Nov 2010 19:03:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
Message-ID: <20101129180324.GA14046@elte.hu>
References: <20101121133744.GA10765@elte.hu>
 <1290700829.4759.16.camel@maggy.simson.net>
 <1290954299.30515.15.camel@marge.simson.net>
 <AANLkTin5Z_WdAPDfcS3V3DCcN40HLDfpzK-o0XeSMiQh@mail.gmail.com>
 <20101128201851.GA20555@elte.hu>
 <1291031593.32004.19.camel@laptop>
 <AANLkTimQ2Kp2=um9ip7J2=-joskmz4P-0b_SrexFbTh0@mail.gmail.com>
 <1291052268.32004.171.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291052268.32004.171.camel@laptop>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2010-11-29 at 08:27 -0800, Linus Torvalds wrote:
> > On Mon, Nov 29, 2010 at 3:53 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > >
> > > Well we totally re-wrote the cgroup load-balancer in -tip. The thing
> > > currently in -linus is a utter crap because its very strongly serialized
> > > across all cores (some people spend like 25% of their time in there).
> > 
> > Well, it seems that the rewrite is more crap than the "utter crap" in
> > current -git. What does that make -tip? Super-utter-crap?
> > 
> > Peter - getting the wrong answer quickly is not any better than strong
> > serialization.
> 
> I know, from the testing so far we _thought_ it was fairly sane.
> Apparently there's still some work to do.

Btw., i think it shows the conceptual power of Mike's patch that this cgroups 
scheduling suckage was exposed so clearly. Previously it took weeks (sometimes 
months) for bugs to reach those who are using cgroups.

Thanks,

	Ingo
