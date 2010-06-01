Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0FAIb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 04:31:29 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58219 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab0FAIb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 04:31:28 -0400
Date: Tue, 1 Jun 2010 10:31:26 +0200
From: Jens Axboe <jaxboe@fusionio.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@infradead.org>,
       Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@linbit.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the drbd tree with Linus' tree
Message-ID: <20100601083126.GB3564@kernel.dk>
References: <20100601141324.edf41f7f.sfr@canb.auug.org.au> <20100601081823.GA29991@infradead.org> <20100601182213.479a777e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601182213.479a777e.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01 2010, Stephen Rothwell wrote:
> [Replacing Jens' Oracle address ...]
> 
> Hi Christoph,
> 
> On Tue, 1 Jun 2010 04:18:23 -0400 Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Tue, Jun 01, 2010 at 02:13:24PM +1000, Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > Today's linux-next merge of the drbd tree got a conflict in fs/pipe.c
> > > between commit cc967be54710d97c05229b2e5ba2d00df84ddd64 ("fs: Add missing
> > > mutex_unlock") from Linus' tree and commits
> > > 0191f8697bbdfefcd36e7b8dc3eeddfe82893e4b ("pipe: F_SETPIPE_SZ should
> > > return -EPERM for non-root") and b9598db3401282bb27b4aef77e3eee12015f7f29
> > > ("pipe: make F_{GET,SET}PIPE_SZ deal with byte sizes") from the drbd tree.
> > > 
> > > I fixed it up (see below) and can carry the fix for a while.
> > 
> > Why is the drbd tree touching fs/pipe.c anyway?
> 
> It is based on the block tree.  I assume that it is currently based on a
> version of the block tree that Jens has not yet pushed into
> linux-next.  :-(

Just checked, and it is indeed for-next that is behind... Will update
it.

-- 
Jens Axboe

