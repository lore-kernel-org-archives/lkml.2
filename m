Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934771Ab2JaPww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 11:52:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55421 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934529Ab2JaPwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 11:52:50 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: mchehab@infradead.org, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] staging: media: Fix minor typo in staging/media
Date: Thu,  1 Nov 2012 00:52:45 +0900
Message-Id: <1351698765-15360-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in comment witin staging/media.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/media/as102/as10x_cmd_cfg.c | 2 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.c | 2 +-
 drivers/staging/media/lirc/lirc_sasem.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/as102/as10x_cmd_cfg.c b/drivers/staging/media/as102/as10x_cmd_cfg.c
index d2a4bce..4a2bbd7 100644
--- a/drivers/staging/media/as102/as10x_cmd_cfg.c
+++ b/drivers/staging/media/as102/as10x_cmd_cfg.c
@@ -197,7 +197,7 @@ out:
  * @prsp:       pointer to AS10x command response buffer
  * @proc_id:    id of the command
  *
- * Since the contex command reponse does not follow the common
+ * Since the contex command response does not follow the common
  * response, a specific parse function is required.
  * Return 0 on success or negative value in case of error.
  */
diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 2e7b711..0ce1fc5 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -783,7 +783,7 @@ dt3155_init_board(struct pci_dev *pdev)
 	}
 	write_i2c_reg(pd->regs, CONFIG, pd->config); /*  ACQ_MODE_EVEN  */
 
-	/* select chanel 1 for input and set sync level */
+	/* select channel 1 for input and set sync level */
 	write_i2c_reg(pd->regs, AD_ADDR, AD_CMD_REG);
 	write_i2c_reg(pd->regs, AD_CMD, VIDEO_CNL_1 | SYNC_CNL_1 | SYNC_LVL_3);
 
diff --git a/drivers/staging/media/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
index f4e4d90..101ac12 100644
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@ -891,7 +891,7 @@ exit:
 }
 
 /**
- * Callback function for USB core API: disonnect
+ * Callback function for USB core API: disconnect
  */
 static void sasem_disconnect(struct usb_interface *interface)
 {
-- 
1.8.0.rc3.16.g8ead1bf

