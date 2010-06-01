Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab0FAIWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 04:22:50 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54803 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316Ab0FAIWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 04:22:48 -0400
Date: Tue, 1 Jun 2010 10:22:47 +0200
From: Jens Axboe <jaxboe@fusionio.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@linbit.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the drbd tree with Linus' tree
Message-ID: <20100601082246.GA3564@kernel.dk>
References: <20100601141324.edf41f7f.sfr@canb.auug.org.au> <20100601081823.GA29991@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601081823.GA29991@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01 2010, Christoph Hellwig wrote:
> On Tue, Jun 01, 2010 at 02:13:24PM +1000, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next merge of the drbd tree got a conflict in fs/pipe.c
> > between commit cc967be54710d97c05229b2e5ba2d00df84ddd64 ("fs: Add missing
> > mutex_unlock") from Linus' tree and commits
> > 0191f8697bbdfefcd36e7b8dc3eeddfe82893e4b ("pipe: F_SETPIPE_SZ should
> > return -EPERM for non-root") and b9598db3401282bb27b4aef77e3eee12015f7f29
> > ("pipe: make F_{GET,SET}PIPE_SZ deal with byte sizes") from the drbd tree.
> > 
> > I fixed it up (see below) and can carry the fix for a while.
> 
> Why is the drbd tree touching fs/pipe.c anyway?

A quick guess would be that it's based off for-linus in the block tree,
which has a patch or two in that area. Why it would conflict and simply
not note that it's the same change, perhaps a rebase or something? Not
sure.

-- 
Jens Axboe

