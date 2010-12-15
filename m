Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab0LOGDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 01:03:01 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:28230 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332Ab0LOGC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 01:02:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHvnB015Lc+z/2dsb2JhbACkG3nBL4VKBA
Date: Wed, 15 Dec 2010 17:02:53 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: sedat.dilek@gmail.com, Sedat Dilek <sedat.dilek@googlemail.com>,
        Nick Piggin <npiggin@kernel.dk>, Nick Kossifidis <mickflemm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Hutterer <peter.hutterer@who-t.net>
Subject: Re: linux-next: Tree for December 14 (New tree: vfs-scale)
Message-ID: <20101215060253.GD3398@amd>
References: <AANLkTi=LG5Sbnu-_gHu5C0-mowBUAPWBmNHn0+e6LTyZ@mail.gmail.com>
 <20101214223339.5bf5db49.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214223339.5bf5db49.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 10:33:39PM +1100, Stephen Rothwell wrote:
> Hi Sedat,
> 
> On Tue, 14 Dec 2010 10:38:35 +0100 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> > I played yesterday with the new refreshed patchset (manually merged
> > and fixed) against systemd-v15 with kgdb/kdb.
> > Oh yes, there is a "dmesg" command :-) and with "btp $pid" I yesterday
> > night saw a NULL dereference in the backtrace.
> > Currently, I am compiling linux-next (next-20101214) and will take
> > some pictures with my digicam.

Thanks for testing, I would be very interested to know if your bug
has gone away or not, we never quite got to the bottom of that. BTW.
capturing the top of the oops is important, if possible. If you don't
have a serial console or anything to capture it, could you try
increasing the resolution of your console so it fits more in?


> > Some recommends (not that I want to teach you as GIT is for me new
> > playground and I follow mostly the commit-messages, which not means I
> > understand the complexity of the patchset), but ...
> > 
> > 1. Please give commits a proper/sane "commit subject"
> > "Build fix" or "Fixed build failure" is not saying much.

Yes, that will be folded in properly before upstream merge.


> > 2. Add credits for people investing time to test and report
> > Same commits did not have also credits for people reporting the build failures.
> > A reference to LKML posting would be fine in the "commit-body" (sorry
> > for my comparison with Email, do not know the GIT term).
> > 
> > This all is not to punish you, it is for following and documenting the
> > whole process.
> > 
> > Peter Hutterer has a wonderful blog article "On commit messages"
> > concerning this topic.
> > If all of us would follow them, the working-together will be more fruitful.

That is a good point, and if I don't give testers enough credit, I'm
sorry because they're a vital part of the chain. Probably because I
have too many bugs that it would clutter my changelogs to credit
everyone who finds one :)

I definitely like to credit testers and reporters in bugfix patches to
upstream kernel, but I find that when they're testing a development
kernel, then the bugfix patches get merged back into the patch that
introduces the bug before being merged.

It wouldn't hurt to keep references to these problems though, not only
to acknoledge the testers, but also as a reference to potential pitfalls
or problematic areas in the commit.

So, I'll try to take your suggestion on board.

Thanks,
Nick

