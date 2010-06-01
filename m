Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab0FAKvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 06:51:00 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36430 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab0FAKu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 06:50:56 -0400
Date: Tue, 1 Jun 2010 12:50:56 +0200
From: Jens Axboe <jaxboe@fusionio.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@infradead.org>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       "drbd-dev@linbit.com" <drbd-dev@linbit.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the drbd tree with Linus' tree
Message-ID: <20100601105055.GN3564@kernel.dk>
References: <20100601141324.edf41f7f.sfr@canb.auug.org.au> <20100601081823.GA29991@infradead.org> <20100601182213.479a777e.sfr@canb.auug.org.au> <20100601104515.GM3564@kernel.dk> <20100601204942.134965e5.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601204942.134965e5.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01 2010, Stephen Rothwell wrote:
> HI Jens,
> 
> On Tue, 1 Jun 2010 12:45:15 +0200 Jens Axboe <jaxboe@fusionio.com> wrote:
> >
> > So the pipe patches were the same, the problem was that a fix for a
> > missing pipe_unlock() had gone into mainline and for-linus/for-next
> > weren't synced up to that. I'm guessing you pull drbd before for-next
> > and that is why it showed up there.
> 
> Actually, I merge the drbd tree after the block tree and this fell to the
> drbd tree only because your for-next branch had not been updated (and I
> don't merge your for-linus branch).

Ah I see, then it all adds up.

> > BTW, I would recommend moving for-next from the block tree up before any
> > potential other trees being based off it if that is the case.
> 
> That is already true.

Good!

-- 
Jens Axboe

