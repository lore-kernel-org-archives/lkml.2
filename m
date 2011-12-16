Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206Ab1LPMza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 07:55:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:34162 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab1LPMzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 07:55:25 -0500
Message-ID: <4EEB3FBB.6090109@kernel.dk>
Date: Fri, 16 Dec 2011 13:55:23 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block IO fixes for 3.2-rc5
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A few bug fixes for block IO related bits for 3.2-rc. Please pull!

  git://git.kernel.dk/linux-block.git for-linus

Benjamin Herrenschmidt (1):
      block/swim3: Locking fixes

Dave Young (1):
      loop: fix loop block driver discard and encryption comment

Lukas Czerner (1):
      loop: Fix discard_alignment default setting

Mike Snitzer (1):
      block: initialize request_queue's numa node during

Stephen M. Cameron (2):
      cciss: Add IRQF_SHARED back in for the non-MSI(X) interrupt handler
      cciss: fix flush cache transfer length

Tejun Heo (1):
      block: don't kick empty queue in blk_drain_queue()

Yasuaki Ishimatsu (1):
      cfq-iosched: fix cfq_cic_link() race confition

majianpeng (1):
      cfq-iosched: free cic_index if blkio_alloc_blkg_stats fails

 block/blk-core.c       |   23 ++--
 block/cfq-iosched.c    |   16 ++-
 drivers/block/cciss.c  |    6 +-
 drivers/block/loop.c   |    4 +-
 drivers/block/swim3.c  |  362 ++++++++++++++++++++++++++++--------------------
 include/linux/blkdev.h |    3 -
 6 files changed, 246 insertions(+), 168 deletions(-)

-- 
Jens Axboe

