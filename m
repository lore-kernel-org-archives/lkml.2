Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab1BKOni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:43:38 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:43398 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752260Ab1BKOnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:43:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:X-Identified-User;
	b=BI7D8qdfvWKCtXF5dBy7Q5Hy5xtNzfLAS2pqcwaUyWUJKeWAgIyyZtf9JnDF5wSHenOQHMU+qta5lGO6p6Vm9YrSN0Ul9HfmMcMz5ick7NtENw/vRDAWrzNx67r9uOTM;
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jaxboe@fusionio.com>
Subject: [PATCH] block: remove obsolete comments for blkdev_issue_zeroout.
Date: Fri, 11 Feb 2011 22:43:06 +0800
Message-Id: <1297435386-2914-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 221.217.51.11 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

barrier is already removed, so remove the obsolete comments
in blkdev_issue_zeroout.

Cc: Jens Axboe <jaxboe@fusionio.com>
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
1.7.1

