Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab0JMMUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 08:20:06 -0400
Received: from canuck.infradead.org ([134.117.69.58]:35121 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab0JMMUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 08:20:04 -0400
Date: Wed, 13 Oct 2010 08:20:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101013122002.GA10831@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-18-git-send-email-david@fromorbit.com>
 <20101013072058.GA3121@amd>
 <20101013072701.GB3121@amd>
 <20101013112827.GC16422@infradead.org>
 <20101013120307.GA5883@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013120307.GA5883@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 11:03:07PM +1100, Nick Piggin wrote:
> On Wed, Oct 13, 2010 at 07:28:27AM -0400, Christoph Hellwig wrote:
> > On Wed, Oct 13, 2010 at 06:27:01PM +1100, Nick Piggin wrote:
> > > I'm happy to help to port the top of the patch set onto changes in
> > > earlier parts of it, but I would like the chance to do this really. I'm
> > > back in action now, so I can spend a lot of time catching up.
> > 
> > That's all good and fine, but it's really no reason for delaying getting
> > the most important bits in.
> 
> Really? I *really* think I can be given the chance to review what's
> happened, catch up, and make sure it's foward compatible with the
> rest of my tree.

Please go and review it, the more eyes core code gets the better.  But
don't assume you have carte blanche to delay things again just for the
fun of it.  Other patches in your tree will need at least as many
changes as the inode bits did, so they will need some major work anyway.
Holding the splitup now for things that will take at least another half
a year to hit the tree is rather pointless.

> The most important bits are, in fact, mostly my
> patches anyway unless there is a fundamentally different approach to
> take. And so either way I don't think it is ready for 2.6.37 if it
> hasn't been in vfs for testing and review by fs people -- that's what
> we agreed I thought for the inode and dcache lock splitups.

fs and vfs people have been reviewing the code for the last couple of
weeks, and we're almost done.  Unless we'll find anoher issue it
should go into the vfs tree.  Given that we don't even have a vfs
tree for .37 yet there's no way we could have put it in earlier anyay..

