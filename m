Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab1HBSzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 14:55:21 -0400
Received: from 1wt.eu ([62.212.114.60]:38438 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755020Ab1HBSzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 14:55:13 -0400
Date: Tue, 2 Aug 2011 20:55:01 +0200
From: Willy Tarreau <w@1wt.eu>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [stable] [ANNOUNCE] The longterm Linux 2.6.35.14 kernel is released
Message-ID: <20110802185501.GC32027@1wt.eu>
References: <20110801215908.GA11448@tassilo.jf.intel.com> <87sjpk9ttf.fsf@turtle.gmx.de> <20110802181751.GB7087@tassilo.jf.intel.com> <87aabraca3.fsf@turtle.gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aabraca3.fsf@turtle.gmx.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 08:39:16PM +0200, Sven Joachim wrote:
> > I checked the tree on master, it is uptodate. Don't know why it's 
> > not reaching the main git server. Maybe have to wait a bit longer.
> 
> I don't think that's the problem, since the v2.6.35.14 tag and the
> commits that lead to it have been at
> git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.35.y.git for
> at least twelve hours.  The problem is that while the tag is there, the
> master branch is still at v2.6.35.13-original.  This happens if you just
> "git push v2.6.35.14" without _also_ explicitly pushing the master
> branch.  In that case, the commits leading to v2.6.35.14 get pushed (and
> can be fetched with "git fetch -t") but are not on any branch.
> 
> Linus himself had already made this mistake at least twice, so it can
> happen to anyone, I guess. :-)

I too made this mistake a few times. However I just checked Andi's tree
on hera and it's OK, master == v2.6.35.14, so possibly this is just a
synchronization issue. Let's wait a bit.

Cheers,
Willy

