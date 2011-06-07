Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab1FGLv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 07:51:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43422 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab1FGLvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 07:51:55 -0400
Date: Tue, 7 Jun 2011 13:51:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
        Paul Mundt <lethal@linux-sh.org>, Nick Piggin <npiggin@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] slob/lockdep: Fix gfp flags passed to lockdep
Message-ID: <20110607115137.GA25798@elte.hu>
References: <1307369665.31814.20.camel@gandalf.stny.rr.com>
 <alpine.DEB.2.00.1106062106580.22635@chino.kir.corp.google.com>
 <BANLkTikmp5CFKykBXaPUP0SBZEto1idDsA@mail.gmail.com>
 <20110607101948.GB21356@elte.hu>
 <1307445322.31814.23.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307445322.31814.23.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 2011-06-07 at 12:19 +0200, Ingo Molnar wrote:
> > * Pekka Enberg <penberg@kernel.org> wrote:
> 
> > > However, I'm not pulling from a "tip/lockdep/devel" branch to slab.git
> > > so Steven needs to send this to me in patch format or Ingo picks it up
> > > in which case consider the patch:
> > > 
> > > Acked-by: Pekka Enberg <penberg@kernel.org>
> > 
> > Unless there are some dependencies i missed i think it would be 
> > better if you pulled this, hm?
> 
> Nope, this is my fault. I searched for SLOB in MAINTAINERS and didn't
> find it. But I should have looked at SLAB.
> 
> I'll resend this as a normal patch for Pekka.

Pekka could pull it as well, since you've already tested that tree 
:-)

I don't think this tree includes any other commits, right?

Thanks,

	Ingo
