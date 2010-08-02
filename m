Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab0HBCd3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 22:33:29 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:59188 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751827Ab0HBCd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 22:33:28 -0400
Date: Mon, 2 Aug 2010 12:33:22 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.35
Message-ID: <20100802023322.GA19164@dastard>
References: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 01, 2010 at 04:52:42PM -0700, Linus Torvalds wrote:
> On a slightly happier note: one thing I do hope we can merge in the
> upcoming merge window is Nick Piggin's cool VFS scalability series.
> I've been using it on my own machine, and gone through all the commits
> (not that I shouldn't go through some of them some more), and am
> personally really excited about it. It's seldom we see major
> performance improvements in core code that are quite that noticeable,
> and Nick's whole RCU pathname lookup in particular just tickles me
> pink.

There hasn't been nearly enough review or testing of this patch
series yet.  Before a merge, it needs to be split up in smaller,
more digestable chunks for more comprehensive review, regression
testing and behavioural analysis.

There's probably only a handful of people who have done any testing
on the patchset so far, and given the widespread changes it needs a
lot more testing than this before we should consider merging any of
it.

I really want to see this move forward too, but it changes lots of
critical infrastructure in subtle ways and so, IMO, this is not
a patchset we should be gung-ho about.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
