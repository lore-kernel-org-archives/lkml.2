Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab2IDJkC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 05:40:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35494 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756634Ab2IDJkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 05:40:01 -0400
Date: Tue, 4 Sep 2012 11:39:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] floppy, pktcdvd
Message-ID: <alpine.LNX.2.00.1209041134240.23857@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

please consider pulling from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/linux-block.git for-jens

(based on 'master' of your linux-block.git) to receive the changes below.

There are a couple of fixes (mostly clenaups) to floppy driver from Herton 
Ronaldo Krzesinski and Ben Hutchings.

Ben's fix I'd like to explicitly point out, as it slightly modifies how 
GENHD_FL_UP is handled in block/genhd.c, but as you have been CCed on it 
and didn't object, I am including it as well.

Apart from that, Peter is giving up on pktcdvd maintainer ship, so I 
offered to take it, cosidering that I have the necessary hardware and it's 
a very low-traffic code anyway.

Thanks!

Ben Hutchings (1):
      genhd: Make put_disk() safe for disks that have not been registered

Herton Ronaldo Krzesinski (5):
      floppy: don't call alloc_ordered_workqueue inside the alloc_disk loop
      floppy: do put_disk on current dr if blk_init_queue fails
      floppy: properly handle failure on add_disk loop
      floppy: use common function to check if floppies can be registered
      floppy: remove dr, reuse drive on do_floppy_init

Jiri Kosina (1):
      pktcdvd: update MAINTAINERS

 MAINTAINERS            |    2 +-
 block/genhd.c          |    6 +-
 drivers/block/floppy.c |   97 +++++++++++++++++++++++------------------------
 3 files changed, 51 insertions(+), 54 deletions(-)

-- 
Jiri Kosina
SUSE Labs
