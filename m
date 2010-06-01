Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab0FAD1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:27:31 -0400
Received: from mail.perches.com ([173.55.12.10]:2468 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426Ab0FADX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:23:26 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com
Subject: [PATCH 04/21] drivers/block/cciss_scsi.c: Remove unnecessary kmalloc casts
Date: Mon, 31 May 2010 20:23:06 -0700
Message-Id: <839dcab1f4fae391567c600dd515ede10232cfd4.1275360951.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <cover.1275360951.git.joe@perches.com>
References: <cover.1275360951.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/cciss_scsi.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index e1d0e2c..ffd8470 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -702,8 +702,7 @@ cciss_scsi_setup(int cntl_num)
 	struct cciss_scsi_adapter_data_t * shba;
 
 	ccissscsi[cntl_num].ndevices = 0;
-	shba = (struct cciss_scsi_adapter_data_t *)
-		kmalloc(sizeof(*shba), GFP_KERNEL);	
+	shba = kmalloc(sizeof(*shba), GFP_KERNEL);
 	if (shba == NULL)
 		return;
 	shba->scsi_host = NULL;
-- 
1.7.0.3.311.g6a6955

