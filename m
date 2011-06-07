Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab1FGKUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:20:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36750 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab1FGKUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:20:03 -0400
Date: Tue, 7 Jun 2011 12:19:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
        Paul Mundt <lethal@linux-sh.org>, Nick Piggin <npiggin@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] slob/lockdep: Fix gfp flags passed to lockdep
Message-ID: <20110607101948.GB21356@elte.hu>
References: <1307369665.31814.20.camel@gandalf.stny.rr.com>
 <alpine.DEB.2.00.1106062106580.22635@chino.kir.corp.google.com>
 <BANLkTikmp5CFKykBXaPUP0SBZEto1idDsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikmp5CFKykBXaPUP0SBZEto1idDsA@mail.gmail.com>
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

> On Tue, Jun 7, 2011 at 7:09 AM, David Rientjes <rientjes@google.com> wrote:
> >> Please pull the latest tip/lockdep/devel tree, which can be found at:
> >>
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> >> tip/lockdep/devel
> >>
> >>
> >> Steven Rostedt (1):
> >>       slob/lockdep: Fix gfp flags passed to lockdep
> >
> > Shouldn't this be going into Pekka's slab tree?
> 
> That's what I'd expect, sure. :-)
> 
> However, I'm not pulling from a "tip/lockdep/devel" branch to slab.git
> so Steven needs to send this to me in patch format or Ingo picks it up
> in which case consider the patch:
> 
> Acked-by: Pekka Enberg <penberg@kernel.org>

Unless there are some dependencies i missed i think it would be 
better if you pulled this, hm?

Thanks,

	Ingo
