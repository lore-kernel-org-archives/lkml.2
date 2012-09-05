Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938Ab2IEQeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 12:34:07 -0400
Received: from masquerade.micron.com ([137.201.242.130]:25447 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab2IEQeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 12:34:04 -0400
Message-ID: <50477EF4.7040100@micron.com>
Date: Wed, 5 Sep 2012 22:03:56 +0530
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>,
        "Selvan Mani (smani) [CONT - Type 2]" <smani@micron.com>
Subject: [PATCH 5/6] mtip32xx: Change printk to pr_xxxx
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19164.003
X-TM-AS-Result: No-7.702300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed printk to be compliant with latest style changes

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Selvan Mani <smani@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 06bc273..362ce4a 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4213,12 +4213,12 @@ static int __init mtip_init(void)
 {
 	int error;
 
-	printk(KERN_INFO MTIP_DRV_NAME " Version " MTIP_DRV_VERSION "\n");
+	pr_info(MTIP_DRV_NAME " Version " MTIP_DRV_VERSION "\n");
 
 	/* Allocate a major block device number to use with this driver. */
 	error = register_blkdev(0, MTIP_DRV_NAME);
 	if (error <= 0) {
-		printk(KERN_ERR "Unable to register block device (%d)\n",
+		pr_err("Unable to register block device (%d)\n",
 		error);
 		return -EBUSY;
 	}
@@ -4227,7 +4227,7 @@ static int __init mtip_init(void)
 	if (!dfs_parent) {
 		dfs_parent = debugfs_create_dir("rssd", NULL);
 		if (IS_ERR_OR_NULL(dfs_parent)) {
-			printk(KERN_WARNING "Error creating debugfs parent\n");
+			pr_warn("Error creating debugfs parent\n");
 			dfs_parent = NULL;
 		}
 	}
-- 
1.7.1

