Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab0LFWKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:10:39 -0500
Received: from mail.perches.com ([173.55.12.10]:2336 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208Ab0LFWFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:22 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/29] drivers/block: Update WARN uses
Date: Mon,  6 Dec 2010 14:04:58 -0800
Message-Id: <ebe06f607e891477e0bdc762bf2f781237832025.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Format neatening.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 3951020..311454f 100644
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
1.7.3.2.245.g03276.dirty

