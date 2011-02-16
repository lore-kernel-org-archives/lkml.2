Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812Ab1BPJWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 04:22:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51592 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758811Ab1BPJWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 04:22:34 -0500
Date: Wed, 16 Feb 2011 10:22:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, Steven Rostedt <rostedt@goodmis.org>,
        gregkh@suse.de, srostedt <srostedt@redhat.com>, a.p.zijlstra@chello.nl,
        ghaskins@novell.com, stable@kernel.org, stable-commits@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Patch "sched: Give CPU bound RT tasks preference" has been added
 to the 2.6.32-longterm tree
Message-ID: <20110216092203.GD18842@elte.hu>
References: <12978046423644@kroah.org>
 <1297810967.23343.122.camel@gandalf.stny.rr.com>
 <1297821667.5126.11.camel@marge.simson.net>
 <20110216082559.GA16529@elte.hu>
 <4D5B90E8.6080605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5B90E8.6080605@gmail.com>
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


[ about -stable merge policy ]

* Jiri Slaby <jirislaby@gmail.com> wrote:

> > We try to concentrate on regression fixes though.
> 
> Hi, I cannot fully agree with this. The question is who are "we" here?

It's the upstream policy and the scheduler tree certainly follows it.

I think i remember Linus having stated it before (cannot find the mail), but it's 
pretty common-sense so easy to reproduce (i've Cc:-ed Linus in case he wants to 
chime in):

   The idea is to treat Linus's tree and -stable as an organic whole: so -stable
   is upstream as well, but with *bug* fixes backported. It's emphatically not a 
   separate "for backporting interesting/important bits" tree.

   And as such whatever a maintainer can send to Linus in -rc's (in particular late
   -rc's) is -stable eligible.

   For the rest of patches: generally not eligible, but with common-sense 
   exceptions.

   "It's a nice patch" or "it will obviously not cause problems" or "this is
   important to us" does not make a patch eligible for -stable.

   Adding a -stable tag to a commit and *not* sending it to Linus for the next -rc
   also makes a patch almost automatically *not* eligible: if it was not important
   enough to have it in the next -rc then it's doubly not eligible for -stable ...

   I think this common-sense rule is easy to follow:

    " If you ever have to ask yourself whether a patch queued up for -stable is 
      really -stable eligible it probably isnt. "

   It's called -stable for a reason.

Thanks,

	Ingo
