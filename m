Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab2BBRZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:25:57 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:55812
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756377Ab2BBRZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:25:54 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: jack_wang@usish.com, lindar_liu@usish.com, linux-scsi@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH v2] [trivial] pm8001: Fix typo in pm8001_hwi.c
Date: Fri,  3 Feb 2012 02:25:22 +0900
Message-Id: <1328203522-3862-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct typo "unresgister" to "unregister" and "deviece" to
"device" in drivers/scsi/pm8001/pm8001_hwi.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index b7b92f7..e12c4f6 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3532,7 +3532,7 @@ static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	case OPC_OUB_DEREG_DEV:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("unresgister the deviece\n"));
+			pm8001_printk("unregister the device\n"));
 		mpi_dereg_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GET_DEV_HANDLE:
-- 
1.7.6.5

