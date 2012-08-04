Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab2HDMHg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 08:07:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40886 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2HDMHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 08:07:35 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: axboe@kernel.dk, tj@kernel.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH 1/3] Documentation: update missing index files in block/00-INDEX
Date: Sat,  4 Aug 2012 08:07:20 -0400
Message-Id: <1344082040-2587-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update missing index files in block/00-INDEX.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 Documentation/block/00-INDEX |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/block/00-INDEX b/Documentation/block/00-INDEX
index d111e3b..d18ecd8 100644
--- a/Documentation/block/00-INDEX
+++ b/Documentation/block/00-INDEX
@@ -3,15 +3,21 @@
 biodoc.txt
 	- Notes on the Generic Block Layer Rewrite in Linux 2.5
 capability.txt
-	- Generic Block Device Capability (/sys/block/<disk>/capability)
+	- Generic Block Device Capability (/sys/block/<device>/capability)
+cfq-iosched.txt
+	- CFQ IO scheduler tunables
+data-integrity.txt
+	- Block data integrity
 deadline-iosched.txt
 	- Deadline IO scheduler tunables
 ioprio.txt
 	- Block io priorities (in CFQ scheduler)
+queue-sysfs.txt
+	- Queue's sysfs entries
 request.txt
 	- The members of struct request (in include/linux/blkdev.h)
 stat.txt
-	- Block layer statistics in /sys/block/<dev>/stat
+	- Block layer statistics in /sys/block/<device>/stat
 switching-sched.txt
 	- Switching I/O schedulers at runtime
 writeback_cache_control.txt
-- 
1.7.9.5

