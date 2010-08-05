Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331Ab0HETpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 15:45:19 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:43852 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759273Ab0HETpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 15:45:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAB2yWkx5LdAL/2dsb2JhbACgP3LHQ4U6BA
Date: Fri, 6 Aug 2010 05:45:07 +1000
From: Nick Piggin <npiggin@suse.de>
To: Ed Tomlinson <edt@aei.ca>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: Transparent Hugepage Support #29
Message-ID: <20100805194507.GA32496@amd>
References: <20100803135615.GG6071@random.random>
 <201008050727.25253.edt@aei.ca>
 <20100805114915.GA25503@random.random>
 <201008050758.04918.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008050758.04918.edt@aei.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 07:57:52AM -0400, Ed Tomlinson wrote:
> On Thursday 05 August 2010 07:49:15 Andrea Arcangeli wrote:
> > On Thu, Aug 05, 2010 at 07:27:24AM -0400, Ed Tomlinson wrote:
> > > On a tree with:
> > > 
> > > commit 9d9cec888c3c4a2d5b5f01c3f3984fc4bc602681
> > > Merge: dd6c927 9edd35f
> > > Author: Ed <edt@aei.ca>
> > > Date:   Wed Aug 4 15:18:53 2010 -0400
> > > 
> > >     Merge branch 'vfs-scale-working' of git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin into vfs-scaling
> > > 
> > > merged on top of
> > > 
> > > commit 9fe6206f400646a2322096b56c59891d530e8d51
> > > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > > Date:   Sun Aug 1 15:11:14 2010 -0700
> > > 
> > >     Linux 2.6.35
> > 
> > Well I didn't realize you also merged 2.6.35 on top of it. This is no
> > standard tree, so I suggest you to checkout -f origin/master of Nick's
> > tree until he updates to 2.6.35 himself (then I can port to it).
> 
> Nick,
> 
> Any chance of the above happening?  I'd love to test both the vfs scaling changes
> and Andrea's much improved hugepage support together on top of .35

Try vfs-scale branch now. Cleaned up and rebased on 2.6.35 although it
is not as well tested as I would like but I won't have any more time on
it until next week.

vfs-scale-working retained history of fixes. I'll start another
vfs-scale-working-2.6.36 branch for new fixes.

Thanks,
Nick


