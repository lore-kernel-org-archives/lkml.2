Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab0JMMaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 08:30:14 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:16429 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754076Ab0JMMaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 08:30:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACZDtUx5Lc/f/2dsb2JhbAChS3K6eoVIBI9A
Date: Wed, 13 Oct 2010 23:30:08 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101013123008.GA6067@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-18-git-send-email-david@fromorbit.com>
 <20101013072058.GA3121@amd>
 <20101013112552.GB16422@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013112552.GB16422@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 07:25:52AM -0400, Christoph Hellwig wrote:
> On Wed, Oct 13, 2010 at 06:20:58PM +1100, Nick Piggin wrote:
> > Unfortunate timing that everybody is suddenly interested in the
> > scalability work :)
> 
> People have been interested for a long time.  It's just that we finally
> made forward progress to get parts of it shape for merging, which should
> have been done long time ago.

It has been pretty close, IMO, it just needed some more reviewers, which
it only just got really.

 
> > I might need a little more time than 2.6.37! But I'll try my best.
> > I don't think the patchset has suddenly become vastly more urgent
> > in the past month, so I think my approach of having it get a lot
> > of testing and go in Al's vfs tree for a while is best.
> 
> It's always been quite urgent.  Both inode_lock and dcache_lock
> contention have been hurting us for a while.

Yes I know it has been urgent for several years, but it hasn't been
treated that way by vfs people until really so late that it is going to
hurt a lot for people deploying Linux now or using enterprise distros
etc. I had to really learn most of the code from scratch to get this far
and got quite little constructive review really until recently. Anyway
that's nothing to be done about that now. I don't think there should be
any significant delay in me catching up, really.

Thanks,
Nick
