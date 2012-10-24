Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab2JXFrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 01:47:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44428 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab2JXFrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 01:47:06 -0400
Date: Wed, 24 Oct 2012 07:47:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>, peterz@infradead.org,
        mingo@redhat.com, devel@openvz.org, linux-kernel@vger.kernel.org,
        xemul@parallels.com
Subject: Re: [PATCH v5] posix timers: allocate timer id per process
Message-ID: <20121024054700.GA18601@gmail.com>
References: <20121023073913.23514.87934.stgit@localhost.localdomain>
 <1350978723.8609.1555.camel@edumazet-glaptop>
 <alpine.LFD.2.02.1210232345200.2756@ionos>
 <1351029216.6537.3.camel@edumazet-glaptop>
 <alpine.LFD.2.02.1210240004410.2756@ionos>
 <1351047760.6537.6.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351047760.6537.6.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> On Wed, 2012-10-24 at 00:33 +0200, Thomas Gleixner wrote:
> > On Tue, 23 Oct 2012, Eric Dumazet wrote:
> > 
> > > On Tue, 2012-10-23 at 23:47 +0200, Thomas Gleixner wrote:
> > > 
> > > > Not so good to me.
> > > >  
> > > > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > > 
> > > > And that should be either an Acked-by or a Reviewed-by. You can't sign
> > > > off on patches which have not been submitted or transported by you.
> > > 
> > > I actually gave some input, provided a hash function, and so on.
> > > 
> > > So this SOB was valid. I do that all the time.
> > 
> > Not really. I recommend you to read the relevant file in Documentation
> > which covers what can have your SOB. 
> 
> OK I did that again, and found this :
> 
> The Signed-off-by: tag indicates that the signer was involved in the
> development of the patch, or that he/she was in the patch's delivery
> path.
> 
> 
> And I was involved in the development of the patch.
> 
> I understand you dont like it at all, so I'll remember not trying to
> help anymore in this area.

No, you are simply wrong and Linus would (rightfully) complain 
to *Thomas* if he added a SOB like that and pushed such a faulty 
commit to him. Linus has complained about such SOBs before and 
Thomas would be wrong to put them into commits.

SOBs get added if you are the developer of the patch or if you 
are actually one of the 'hops' in the route of the patch that 
gets it to Thomas. SOBs don't get added over email like you did 
and what Thomas pointed out was simply a maintainer's job to 
point out.

Adding credits for helping development get added via different 
tags, not via SOBs.

Thanks,

	Ingo
