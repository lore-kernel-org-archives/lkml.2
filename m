Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab0EGGsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 02:48:06 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37786 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499Ab0EGGsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 02:48:04 -0400
Date: Fri, 7 May 2010 08:48:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Two small fixes for 2.6.34
Message-ID: <20100507064801.GV27497@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Two small fixes for 2.6.34. One fixes a typo in drbd, and the other
fixes a missing RCU lock in the block cgroup code. Please pull.


  git://git.kernel.dk/linux-2.6-block.git for-linus

Jens Axboe (1):
      Merge branch 'for-jens' of git://git.drbd.org/linux-2.6-drbd into for-linus

Lars Ellenberg (1):
      drbd: don't expose failed local READ to upper layers

Vivek Goyal (1):
      blk-cgroup: Fix RCU correctness warning in cfq_init_queue()

 block/cfq-iosched.c              |    2 ++
 drivers/block/drbd/drbd_worker.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

-- 
Jens Axboe

