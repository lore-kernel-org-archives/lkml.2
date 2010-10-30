Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab0J3VQO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:16:14 -0400
Received: from mail.perches.com ([173.55.12.10]:3730 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab0J3VJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:28 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/39] drivers/block: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:25 -0700
Message-Id: <ceacfe2d5b62032a68496e33e90fe557acb3cd44.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Format neatening.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 767107c..b699b18 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3856,7 +3856,7 @@ static int floppy_revalidate(struct gendisk *disk)
 	    test_bit(FD_VERIFY_BIT, &UDRS->flags) ||
 	    test_bit(drive, &fake_change) || NO_GEOM) {
 		if (WARN(atomic_read(&usage_count) == 0,
-			 "VFS: revalidate called on non-open device.\n"))
+			 "VFS: revalidate called on non-open device\n"))
 			return -EFAULT;
 
 		lock_fdc(drive, false);
-- 
1.7.3.1.g432b3.dirty

