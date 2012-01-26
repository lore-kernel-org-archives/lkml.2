Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab2AZPcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 10:32:54 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:37453
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752126Ab2AZPcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 10:32:53 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: hare@suse.de, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] aic7xxx: Fix typo in aic7xxx
Date: Fri, 27 Jan 2012 00:32:19 +0900
Message-Id: <1327591939-2613-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "staus" to "status" in aic79xx_core.c and
Correct spelling "staus" to "status" in aic7xxx_core.c and
Correct spelling "supportd" to "supported" in aic79xx_core.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/aic7xxx/aic79xx_core.c |    4 ++--
 drivers/scsi/aic7xxx/aic7xxx_core.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 5f8617d..25417d0 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -8993,7 +8993,7 @@ ahd_handle_scsi_status(struct ahd_softc *ahd, struct scb *scb)
 					printk("Invalid Command IU Field\n");
 					break;
 				case SIU_PFC_TMF_NOT_SUPPORTED:
-					printk("TMF not supportd\n");
+					printk("TMF not supported\n");
 					break;
 				case SIU_PFC_TMF_FAILED:
 					printk("TMF failed\n");
@@ -9113,7 +9113,7 @@ ahd_handle_scsi_status(struct ahd_softc *ahd, struct scb *scb)
 		break;
 	}
 	case SCSI_STATUS_OK:
-		printk("%s: Interrupted for staus of 0???\n",
+		printk("%s: Interrupted for status of 0???\n",
 		       ahd_name(ahd));
 		/* FALLTHROUGH */
 	default:
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index dc28b0a..10172a3 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -1049,7 +1049,7 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int intstat)
 		ahc_set_scsi_status(scb, hscb->shared_data.status.scsi_status);
 		switch (hscb->shared_data.status.scsi_status) {
 		case SCSI_STATUS_OK:
-			printk("%s: Interrupted for staus of 0???\n",
+			printk("%s: Interrupted for status of 0???\n",
 			       ahc_name(ahc));
 			break;
 		case SCSI_STATUS_CMD_TERMINATED:
-- 
1.7.6.5

