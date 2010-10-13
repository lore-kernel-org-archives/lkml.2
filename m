Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab0JMM0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 08:26:03 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:15003 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754069Ab0JMM0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 08:26:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKM/tUx5Lc/f/2dsb2JhbAChS3K6eYVIBI9A
Date: Wed, 13 Oct 2010 23:25:57 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101013122557.GA6027@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-18-git-send-email-david@fromorbit.com>
 <20101013072058.GA3121@amd>
 <20101013072701.GB3121@amd>
 <20101013112827.GC16422@infradead.org>
 <20101013120307.GA5883@amd>
 <20101013122002.GA10831@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013122002.GA10831@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 08:20:02AM -0400, Christoph Hellwig wrote:
> On Wed, Oct 13, 2010 at 11:03:07PM +1100, Nick Piggin wrote:
> > On Wed, Oct 13, 2010 at 07:28:27AM -0400, Christoph Hellwig wrote:
> > > On Wed, Oct 13, 2010 at 06:27:01PM +1100, Nick Piggin wrote:
> > > > I'm happy to help to port the top of the patch set onto changes in
> > > > earlier parts of it, but I would like the chance to do this really. I'm
> > > > back in action now, so I can spend a lot of time catching up.
> > > 
> > > That's all good and fine, but it's really no reason for delaying getting
> > > the most important bits in.
> > 
> > Really? I *really* think I can be given the chance to review what's
> > happened, catch up, and make sure it's foward compatible with the
> > rest of my tree.
> 
> Please go and review it, the more eyes core code gets the better.  But
> don't assume you have carte blanche to delay things again just for the
> fun of it.

Heh, I'm not, I've been the one driving most of this, so it's not a big
deal. I'm not interested in trying to delay it, trust me, but I think I
can be given some time to review it. It's taken much more than a couple
of weeks for me to get serious reviews...


>  Other patches in your tree will need at least as many
> changes as the inode bits did, so they will need some major work anyway.
> Holding the splitup now for things that will take at least another half
> a year to hit the tree is rather pointless.
> 
> > The most important bits are, in fact, mostly my
> > patches anyway unless there is a fundamentally different approach to
> > take. And so either way I don't think it is ready for 2.6.37 if it
> > hasn't been in vfs for testing and review by fs people -- that's what
> > we agreed I thought for the inode and dcache lock splitups.
> 
> fs and vfs people have been reviewing the code for the last couple of
> weeks, and we're almost done.

Thanks very much, it looks productive. I'm not sure if I agree exactly
with everything but I'll catch up and get back to it.


>  Unless we'll find anoher issue it
> should go into the vfs tree.  Given that we don't even have a vfs
> tree for .37 yet there's no way we could have put it in earlier anyay..

