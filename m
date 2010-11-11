Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab0KKFVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 00:21:25 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:22276 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751407Ab0KKFVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 00:21:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHEK20x5LcZK/2dsb2JhbACiPHK/RoVKBA
Date: Thu, 11 Nov 2010 16:21:18 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] mm: vmscan implement per-zone shrinkers
Message-ID: <20101111052118.GA6484@amd>
References: <20101109123246.GA11477@amd>
 <20101110051813.GS2715@dastard>
 <20101110063229.GA5700@amd>
 <20101110110549.GV2715@dastard>
 <20101111002339.GA3372@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101111002339.GA3372@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 11:23:39AM +1100, Nick Piggin wrote:
> On Wed, Nov 10, 2010 at 10:05:49PM +1100, Dave Chinner wrote:
> > I've previously stated that reducing/controlling the level of
> > parallelism can be just as effective at providing serious
> > scalability improvements as fine grained locking. So you don't
> > simply scoff and mock me for suggesting it like you did last time,
> 
> I didn't mock you. On the contrary I agreed that there are 2 problems
> here, and that lots of threads in reclaim is one of them. I know this

Here, this is the second time I wrote _exactly_ the same reply to your
_exact_ same question (the first time I wrote _exactly_ the same reply
to your exact same question was IIRC a few months before but I couldn't
find the archive.

http://archives.free.net.ph/message/20101015.033017.65c46426.ca.html

So at this point, shut up. You had ample time to put up, and didn't.
Now you're just obstructing and being unreasonable. To quote Christoph,
you don't have carte blance power to delay progress. So stop being an
arsehole, and don't fucking accuse me of scoffing and mocking you.

Because I've been bending over backwards to answer _exactly_ the same
questions multiple times from you and trying to show how either your
assumptions are wrong, or reasonable ways we can mitigate potential
regressions, and trying to be polite and civil the whole time. (which I
might add is much more courtesy than you showed me when you tried to
railroad your inode changes through without bothering to answer or even
read half my comments about them). And what you have done is just ignore
totally my replies to your concerns, stay quiet about them for a month,
and then come back with exactly the same thing again. Like 3 or 4 times.

Really. At this point, if you have already posted a particular comment
more than 50 times, do everybody a favour and redirect the next verbatim
copy /dev/null, OK? I'm sick of it. *Constructive* criticism only, from
now on. Thanks.

I need a zone input to the shinker API, I have demonstrated what for
and why, with good justification, and so I am going to get that API
change merged. It is a simple superset of the current API's
functionality and not some big scary monster (except by somebody who
fundmantally doesn't understand it). 

