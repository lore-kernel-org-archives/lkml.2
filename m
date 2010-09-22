Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab0IVSVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:21:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37331 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab0IVSVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:21:05 -0400
Date: Wed, 22 Sep 2010 20:20:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: John Kacur <jkacur@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@redhat.com, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf build fixes for opensuse 10.0
Message-ID: <20100922182053.GA9058@elte.hu>
References: <20100922090336.GA5338@basil.fritz.box>
 <AANLkTimqa1++9kNcODikTVMOExhypX6+kY_m7dCKb=64@mail.gmail.com>
 <fdf800a16e7e44f19a684d4a4bf67288.squirrel@www.firstfloor.org>
 <AANLkTimqTva4gYncxzeMokT19rYqZ4kj5p=jONYXmP7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimqTva4gYncxzeMokT19rYqZ4kj5p=jONYXmP7Q@mail.gmail.com>
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


* John Kacur <jkacur@redhat.com> wrote:

> On Wed, Sep 22, 2010 at 1:15 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >> On Wed, Sep 22, 2010 at 11:03 AM, Andi Kleen <andi@firstfloor.org> wrote:
> >>> Fix the perf Makefile to compile on opensuse 10.0
> >>>
> >>> -Werror in shipping code is usually a bad idea. Remove that.
> >>
> >> Why not remove it then when you ship the code, but leave it in the kernel
> >> where it is useful?
> >
> > What do you mean with "you ship"?
> 
> The subject of your email is "perf build fixes for opensuse 10.0"
> So, I inferred from there.
> 
> > I downloaded a kernel from kernel.org, it shipped to me and didn't
> > build.
> 
> Any reason you can't fix the build errors instead?

Well, it's Andi - he has a well established track record for picking the 
worst possible solution for pretty much anything and then being 
passive-agressive difficult about it as if there was no tomorrow. It's 
typically quite time-consuming for everyone involved, with little 
productive output. YMMV.

Here he could have done a dozen things to make his posting more useful: 
he could have included the build warnings in the changelog (he didnt), 
he could have tried to address them (he didnt), he could have argued for 
some specific warnings to be disabled on specific, well-established 
grounds, for example demonstrating that it _only_ produces false 
positives (he didnt) - etc. etc. He did none of those things.

Thanks,

	Ingo
