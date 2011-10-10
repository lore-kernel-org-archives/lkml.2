Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab1JJIKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 04:10:11 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:39349 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab1JJIKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 04:10:09 -0400
Subject: [PATCH] [TRIVIAL] aic7xxx: fix Kconfig references to READMEs
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 10:10:02 +0200
Message-ID: <1318234202.29265.1.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/scsi/aic7xxx/Kconfig.aic79xx |    3 +--
 drivers/scsi/aic7xxx/Kconfig.aic7xxx |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/Kconfig.aic79xx b/drivers/scsi/aic7xxx/Kconfig.aic79xx
index 5e6620f..6739069 100644
--- a/drivers/scsi/aic7xxx/Kconfig.aic79xx
+++ b/drivers/scsi/aic7xxx/Kconfig.aic79xx
@@ -31,8 +31,7 @@ config AIC79XX_CMDS_PER_DEVICE
 	on some devices.  The upper bound is 253.  0 disables tagged queueing.
 
 	Per device tag depth can be controlled via the kernel command line
-	"tag_info" option.  See drivers/scsi/aic7xxx/README.aic79xx
-	for details.
+	"tag_info" option.  See Documentation/scsi/aic79xx.txt for details.
 
 config AIC79XX_RESET_DELAY_MS
 	int "Initial bus reset delay in milli-seconds"
diff --git a/drivers/scsi/aic7xxx/Kconfig.aic7xxx b/drivers/scsi/aic7xxx/Kconfig.aic7xxx
index 88da670..55ac55e 100644
--- a/drivers/scsi/aic7xxx/Kconfig.aic7xxx
+++ b/drivers/scsi/aic7xxx/Kconfig.aic7xxx
@@ -36,8 +36,7 @@ config AIC7XXX_CMDS_PER_DEVICE
 	on some devices.  The upper bound is 253.  0 disables tagged queueing.
 
 	Per device tag depth can be controlled via the kernel command line
-	"tag_info" option.  See drivers/scsi/aic7xxx/README.aic7xxx
-	for details.
+	"tag_info" option.  See Documentation/scsi/aic7xxx.txt for details.
 
 config AIC7XXX_RESET_DELAY_MS
 	int "Initial bus reset delay in milli-seconds"
-- 
1.7.4.4



