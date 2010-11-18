Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab0KRJIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:08:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35116 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab0KRJIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:08:40 -0500
Date: Thu, 18 Nov 2010 10:08:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org
Subject: Re: [PATCH 4/9 UPDATED-1] x86: Initialize 32bit logical apicid
 mapping early during boot
Message-ID: <20101118090828.GA28467@elte.hu>
References: <1289473363-29440-1-git-send-email-tj@kernel.org>
 <1289473363-29440-5-git-send-email-tj@kernel.org>
 <4CDD17EC.8000507@kernel.org>
 <20101118083045.GB26398@elte.hu>
 <4CE4E655.30207@kernel.org>
 <20101118084257.GF26398@elte.hu>
 <4CE4E841.9020107@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE4E841.9020107@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 11/18/2010 09:42 AM, Ingo Molnar wrote:
> > This is a very sensitive area of code that tends to blow up in nasty
> > ways. So when we do changes here we want them super-finegrained. If
> > you split it up into 30 reasonable patches - no problem at
> > all. (here up to 5 would suffice i think)
> 
> I'll probably split it to three or four.  That said, I don't really
> think it would help bisection.  But, anyways, no problem.

The most critical patch will of course be the most likely one to regress so a 
split-up does not help bisection per se.

The help this does for us is _fixing_ stuff: we will be looking at a 20 lines patch, 
not a 200 lines one ...

> [...] For now, I would suggest leaving them ugly.  At least
> they're now properly localized after the patchset.

ok. Please add a comment declaring the ugliness and explaining why they are ugly - 
so that future hackers see it as an exception to the rule, not as an example to 
follow ;-)

Thanks,

	Ingo
