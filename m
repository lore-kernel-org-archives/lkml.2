Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab1BOMrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 07:47:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49735 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754539Ab1BOMrq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 07:47:46 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 15 Feb 2011 12:47:36 +0000
Message-ID: <1297774056.17283.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 1/2] block: Fix kernel-doc format for blkdev_issue_zeroout
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 block/blk-lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 1a320d2..eec78be 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -132,7 +132,7 @@ static void bio_batch_end_io(struct bio *bio, int err)
 }
 
 /**
- * blkdev_issue_zeroout generate number of zero filed write bios
+ * blkdev_issue_zeroout - generate number of zero filed write bios
  * @bdev:	blockdev to issue
  * @sector:	start sector
  * @nr_sects:	number of sectors to write
-- 
1.7.2.3



