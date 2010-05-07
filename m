Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab0EGG6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 02:58:41 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33973 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab0EGG6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 02:58:40 -0400
Date: Fri, 7 May 2010 08:58:38 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Two small fixes for 2.6.34
Message-ID: <20100507065838.GX27497@kernel.dk>
References: <20100507064801.GV27497@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507064801.GV27497@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07 2010, Jens Axboe wrote:
> Hi Linus,
> 
> Two small fixes for 2.6.34. One fixes a typo in drbd, and the other
> fixes a missing RCU lock in the block cgroup code. Please pull.
> 
> 
>   git://git.kernel.dk/linux-2.6-block.git for-linus
> 
> Jens Axboe (1):
>       Merge branch 'for-jens' of git://git.drbd.org/linux-2.6-drbd into for-linus
> 
> Lars Ellenberg (1):
>       drbd: don't expose failed local READ to upper layers
> 
> Vivek Goyal (1):
>       blk-cgroup: Fix RCU correctness warning in cfq_init_queue()
> 
>  block/cfq-iosched.c              |    2 ++
>  drivers/block/drbd/drbd_worker.c |    2 +-
>  2 files changed, 3 insertions(+), 1 deletions(-)

Another small RCU block cgroup fix was missed, I've pushed that out now.
New changelog/diffstat:

  git://git.kernel.dk/linux-2.6-block.git for-linus

Jens Axboe (1):
      Merge branch 'for-jens' of git://git.drbd.org/linux-2.6-drbd into for-linus

Lars Ellenberg (1):
      drbd: don't expose failed local READ to upper layers

Li Zefan (1):
      blk-cgroup: Fix an RCU warning in blkiocg_create()

Vivek Goyal (1):
      blk-cgroup: Fix RCU correctness warning in cfq_init_queue()

 block/blk-cgroup.c               |    8 ++++----
 block/cfq-iosched.c              |    2 ++
 drivers/block/drbd/drbd_worker.c |    2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

-- 
Jens Axboe

