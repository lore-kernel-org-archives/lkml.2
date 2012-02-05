Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab2BETLC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 14:11:02 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22704 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab2BETLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 14:11:01 -0500
Date: Sun, 5 Feb 2012 20:11:27 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, trivial@kernel.org
Subject: [PATCH] NVM Express: Remove unneeded include of linux/version.h from
 nvme.c
Message-ID: <alpine.LNX.2.00.1202052009330.32529@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need for drivers/block/nvme.c to include linux/version.h,
so remove the include.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/block/nvme.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/block/nvme.c b/drivers/block/nvme.c
index c1dc4d8..09776da 100644
--- a/drivers/block/nvme.c
+++ b/drivers/block/nvme.c
@@ -39,7 +39,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/types.h>
-#include <linux/version.h>
 
 #define NVME_Q_DEPTH 1024
 #define SQ_SIZE(depth)		(depth * sizeof(struct nvme_command))
-- 
1.7.9


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

