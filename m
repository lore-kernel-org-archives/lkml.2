Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947Ab1FWSkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:40:36 -0400
Received: from mail.perches.com ([173.55.12.10]:3180 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759901Ab1FWSkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:40:25 -0400
From: Joe Perches <joe@perches.com>
To: devel@driverdev.osuosl.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: transciever/transceiver spelling fixes
Date: Thu, 23 Jun 2011 11:40:19 -0700
Message-Id: <d083ca110e602280d33b355ba6884fa124f82a03.1308854062.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc1
In-Reply-To: <3449aeaeff79540bbe60c1323a28c528e3083507.1308854062.git.joe@perches.com>
References: <3449aeaeff79540bbe60c1323a28c528e3083507.1308854062.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just tyops.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/et131x/et1310_phy.c     |    2 +-
 drivers/staging/et131x/et131x_adapter.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 2798a2f..5b5344a 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -99,7 +99,7 @@ static void et131x_xcvr_init(struct et131x_adapter *etdev);
 /**
  * PhyMiRead - Read from the PHY through the MII Interface on the MAC
  * @etdev: pointer to our private adapter structure
- * @xcvrAddr: the address of the transciever
+ * @xcvrAddr: the address of the transceiver
  * @xcvrReg: the register to read
  * @value: pointer to a 16-bit value in which the value will be stored
  *
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index c852f86..e6eafd2 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -118,7 +118,7 @@ typedef struct _ce_stats_t {
 	u32 norcvbuf;	/* # Rx packets discarded */
 	u32 noxmtbuf;	/* # Tx packets discarded */
 
-	/* Transciever state informations. */
+	/* Transceiver state informations. */
 	u8 xcvr_addr;
 	u32 xcvr_id;
 
-- 
1.7.6.rc1

