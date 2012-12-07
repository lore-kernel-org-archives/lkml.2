Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423919Ab2LGCkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 21:40:55 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:61099 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422709Ab2LGCkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 21:40:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al8NAHFWwVB5LHa//2dsb2JhbABEuDqFehdzgh4BAQQBOhwjBQsIAw4KLhQlAyETiAoFwm4UjCWDYmEDlgKQSIMH
Date: Fri, 7 Dec 2012 13:40:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121207024049.GF27172@dastard>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
 <20121206011402.GB27172@dastard>
 <CA+55aFzjOr1tw4UAdWazgvzOu6if8hOc4PqgLeX4Um_k-kuguw@mail.gmail.com>
 <201212061037.56597.Martin@lichtvoll.de>
 <20121207010837.GA16373@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121207010837.GA16373@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 02:08:37AM +0100, Ingo Molnar wrote:
> 
> * Martin Steigerwald <Martin@lichtvoll.de> wrote:
> 
> > > The thing that people are complaining about is exactly the 
> > > reverse of this. It's *protecting* us from making mistakes, 
> > > and doesn't actually add any new interfaces in itself.
> > >
> > > This is why I'm so annoyed with this stupid thread. It's 
> > > been going on forever, and reverting that change WOULD BE 
> > > OBJECTIVELY A BAD IDEA.
> > 
> > See, thats where you have a problem with "reality".
> > 
> > It seems you cannot accept the fact that some developers 
> > disliked the process in which this change was pushed. [...]
> 
> I don't think you have understood Linus's argument above.
> 
> The "process" does not change the object technical merits of a 
> patch. Ever. This patch is _good_, and objectively good. No 
> amount of 'bad process' can make this patch bad.

Yeah, Linus asserted the patch is good, and you're parroting that.
There isn't even any agreement on that level, let alone the other
problems like the fact it introduced undocumented changes to a
syscall API. people get raked over the coals frequently for doing
this sort of stuff, but in this case it's "good because Linus said
so".

Review gives the opportunity to make patches *better*. It might be
a good concept with a bad implementation (which is how I'd
categorise this patch), and review gives us the opportunity to sort
out those problems before we end up in a situation like this.

Especially for changes to syscall APIs....

> Now, hypothetically, if this was an objectively bad patch, then 
> any "bad process" used to push it would add insult to injury and 
> it could be reason enough to flame Tytso twice as hard.

Assumption: the patch is good

Reality: the concept is worthy, but the implmentation and and the
taken were terrible. Patch could be a lot better, but improvement
needs time and for syscall changes already in mainline we don't have
that time. either we revert it or we are stuck with it.

Right now, we're stuck with it....

> But it turns out the patch was right and good, so kudos to Tytso 
> for cutting through the bike shed painting and politicks of 
> fsdevel - which "process" would have deprived us of a good 
> patch...

Assumption: a) it's a good patch and b) review would have prevented
the patch from proceeding.

Reality: a) see above. b) Who can say - it never occurred?
Personally, I'm not opposed to reserving a bit but it needs
documentation and clarification over future scope and kernel
implementation, which review would have caught and the discussion
would have been in that context....

If you can't stand the heat, get out of the kitchen. IOWs, if you
can't defend your change on it's merits, then it shouldn't be made.
Sending your patch through a back door becuse you don't think you
can't defend it as you pass through the front door is simply *not
acceptable*.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
