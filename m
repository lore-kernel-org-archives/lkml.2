Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424137Ab2LGBIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:08:45 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54346 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422942Ab2LGBIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:08:43 -0500
Date: Fri, 7 Dec 2012 02:08:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121207010837.GA16373@gmail.com>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
 <20121206011402.GB27172@dastard>
 <CA+55aFzjOr1tw4UAdWazgvzOu6if8hOc4PqgLeX4Um_k-kuguw@mail.gmail.com>
 <201212061037.56597.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201212061037.56597.Martin@lichtvoll.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Steigerwald <Martin@lichtvoll.de> wrote:

> > The thing that people are complaining about is exactly the 
> > reverse of this. It's *protecting* us from making mistakes, 
> > and doesn't actually add any new interfaces in itself.
> >
> > This is why I'm so annoyed with this stupid thread. It's 
> > been going on forever, and reverting that change WOULD BE 
> > OBJECTIVELY A BAD IDEA.
> 
> See, thats where you have a problem with "reality".
> 
> It seems you cannot accept the fact that some developers 
> disliked the process in which this change was pushed. [...]

I don't think you have understood Linus's argument above.

The "process" does not change the object technical merits of a 
patch. Ever. This patch is _good_, and objectively good. No 
amount of 'bad process' can make this patch bad.

Now, hypothetically, if this was an objectively bad patch, then 
any "bad process" used to push it would add insult to injury and 
it could be reason enough to flame Tytso twice as hard.

But it turns out the patch was right and good, so kudos to Tytso 
for cutting through the bike shed painting and politicks of 
fsdevel - which "process" would have deprived us of a good 
patch...

Thanks,

	Ingo
