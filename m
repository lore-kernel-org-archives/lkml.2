Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab0DMVDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 17:03:20 -0400
Received: from www.tglx.de ([62.245.132.106]:47866 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886Ab0DMVDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 17:03:15 -0400
Date: Tue, 13 Apr 2010 23:02:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Chase Douglas <chase.douglas@canonical.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel-team <kernel-team@lists.ubuntu.com>
Subject: Re: [REGRESSION 2.6.30][PATCH 1/1] sched: defer idle accounting till
 after load update period
In-Reply-To: <20100413133903.9d38a6ee.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004132302010.7682@localhost.localdomain>
References: <1269870072-22449-1-git-send-email-chase.douglas@canonical.com> <1269870072-22449-2-git-send-email-chase.douglas@canonical.com> <20100401122740.a1ae80a7.akpm@linux-foundation.org> <z2i40ec3ea41004011256p281cc601t277c3191fef5f87b@mail.gmail.com>
 <alpine.LFD.2.00.1004012200340.32352@localhost.localdomain> <20100413133903.9d38a6ee.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Apr 2010, Andrew Morton wrote:

> On Thu, 1 Apr 2010 22:01:59 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Thu, 1 Apr 2010, Chase Douglas wrote:
> > > On Thu, Apr 1, 2010 at 3:27 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > Thomas Gleixner seems to think this isn't the best approach (later
> > > email in this thread), so I'm deferring sending it unless someone is
> > > still interested in this approach.
> > 
> > Well, it's a good workaround for now I think, I just answered Andrews
> > question whether we can't do any better :)
> > 
> 
> So... should we merge Chase's patch?

I have no better solution right now. Peter ?

Thanks,

	tglx
 
