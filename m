Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab0FGU6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 16:58:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752289Ab0FGU6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 16:58:14 -0400
Date: Mon, 7 Jun 2010 13:52:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>
cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm fixes
In-Reply-To: <AANLkTimSFtaDzUPDEq4Z2J4O5sFG4vDkFHqs1eA1wG44@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006071342400.4506@i5.linux-foundation.org>
References: <alpine.DEB.2.00.1006070404510.29029@skynet.skynet.ie> <alpine.LFD.2.00.1006071057300.3515@i5.linux-foundation.org> <AANLkTimSFtaDzUPDEq4Z2J4O5sFG4vDkFHqs1eA1wG44@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Jun 2010, Dave Airlie wrote:

> >         26 files changed, 372 insertions(+), 66 deletions(-)
> >
> > and there are apparently several reports of known problems (the problem
> > with modesetting) that isn't even addressed.
> 
> Okay, not sure what the addressed regression you are talking about, do
> you want  regression fixes early like you always say or do you want to
> wait until I have every regression reported fixes before I send a pull
> request?

I absolutely do want regression fixes early. If they've been verified to 
fix something, I do want to merge them as soon as possible.

But EVEN MORE IMPORTANTLY - and the point of me saying no - I do _not_ 
want non-regression fixes mixed in. Which clearly was the case here. So 
"as soon as possible" does not mean that I'll take _other_ things just to 
get the fix. The regression fix should stand on its own - and be merged 
on its own.

So no, it's not an excuse to send me a tree that contains other crud, and 
then use ".. but but you wanted regression fixes" as the excuse for 
sending those other changes too.

The whole point of the merge window is to then _after_ it closes no longer 
merge new code.

> I really hope you do this, if I find one thing going into your tree
> after today that isn't a regression fix I'll send revert patches if
> that'll help.

I don't like seeing revert patches unless they revert something that is 
buggy.  So no, "revert because I shouldn't have sent that commit" is not a 
good policy. If I end pulling something, it's my bad, and I won't revert 
it just because I made a mistake - it needs to be somehow actually be 
involved in some real problem.

But I _am_ trying to be proactive about problems during this particular 
release cycle. 

The point I'm trying to make is that I am going to be strict about the 
rules (the ones we've had for several years now, but people tend to be a 
bit loose about). I _should_ probably be stricter than I usually am even 
normally, but this time I am going to be very strict for -rc3 due to 
being away for part of the release cycle.

And no, don't worry - it's not just for you. I already rejected a 
microblaze pull for all the same reasons, and asked for some extended 
clarifications for a (much smaller) jffs2 pull despite the fact that we've 
generally not had lots of problems with jffs2.

		Linus
