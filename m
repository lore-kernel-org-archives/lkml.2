Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522Ab2JWWdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:33:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:47459 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443Ab2JWWdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:33:13 -0400
Date: Wed, 24 Oct 2012 00:33:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Stanislav Kinsbursky <skinsbursky@parallels.com>, peterz@infradead.org,
        mingo@redhat.com, devel@openvz.org, linux-kernel@vger.kernel.org,
        xemul@parallels.com
Subject: Re: [PATCH v5] posix timers: allocate timer id per process
In-Reply-To: <1351029216.6537.3.camel@edumazet-glaptop>
Message-ID: <alpine.LFD.2.02.1210240004410.2756@ionos>
References: <20121023073913.23514.87934.stgit@localhost.localdomain>  <1350978723.8609.1555.camel@edumazet-glaptop>  <alpine.LFD.2.02.1210232345200.2756@ionos> <1351029216.6537.3.camel@edumazet-glaptop>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012, Eric Dumazet wrote:

> On Tue, 2012-10-23 at 23:47 +0200, Thomas Gleixner wrote:
> 
> > Not so good to me.
> >  
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > 
> > And that should be either an Acked-by or a Reviewed-by. You can't sign
> > off on patches which have not been submitted or transported by you.
> 
> I actually gave some input, provided a hash function, and so on.
> 
> So this SOB was valid. I do that all the time.

Not really. I recommend you to read the relevant file in Documentation
which covers what can have your SOB. 

Your input is documented in the mail thread, but it does not contain a
patch - which is Signed-off-by YOU - on which the thing at hand is
based on. So it's not covered by what SOB actually means.

You can rightfully request the patch author to add a "Suggested-by"
tag, but you can't rightfully claim authorship of something you did
not author.

> And yes, there are bugs in this patch, as many patches that were merged
> in linux tree, included by you.

That's a totally different issue. We can ack/review/signoff and commit
totally bogus patches as long as we want.

Though that does not change the meanings of the tags (Acked, Reviewed,
Signed-off) at all.

Thanks,

	tglx
