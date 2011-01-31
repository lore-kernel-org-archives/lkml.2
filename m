Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab1AaCq3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 21:46:29 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:43847 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752552Ab1AaCq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:46:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:X-Identified-User;
	b=gyKqe6TMzozjyuF5ZF6ZNSQEeNbtEjAOnsT80d8PQQMT4hb6iQDyt72l0GdlNMcdTkfF3UhErIO04HZXgFG2iY7vLJXRCVK/V0S/lLA5kindF8wNNAqxgnj5nY5dK/38;
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] block/trivial: Remove barrier comment in blkdev_issue_zeroout.
Date: Mon, 31 Jan 2011 10:46:10 +0800
Message-Id: <1296441970-9098-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

barrier action is removed from blkdev_issue_zeroout, so
remove the corresponding comment.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 block/blk-lib.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 1a320d2..55da8bd 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -140,8 +140,6 @@ static void bio_batch_end_io(struct bio *bio, int err)
  *
  * Description:
  *  Generate and issue number of bios with zerofiled pages.
- *  Send barrier at the beginning and at the end if requested. This guarantie
- *  correct request ordering. Empty barrier allow us to avoid post queue flush.
  */
 
 int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
-- 
1.6.3.GIT

