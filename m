Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab2JORZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:25:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59400 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab2JORZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:25:02 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 08/14] staging: csr: Removed unnecessary whitespace before newline on io.c
Date: Tue, 16 Oct 2012 02:24:27 +0900
Message-Id: <1350321868-2613-8-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350321868-2613-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350321868-2613-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I removed a few unnecessary whitespace before \n, and now it's done.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/csr/io.c b/drivers/staging/csr/io.c
index cecc1df..934eacd 100644
--- a/drivers/staging/csr/io.c
+++ b/drivers/staging/csr/io.c
@@ -100,7 +100,7 @@ static CsrResult signal_buffer_init(unifi_priv_t * priv, int size)
 		kmalloc(UNIFI_PACKED_SIGBUF_SIZE, GFP_KERNEL);
 		if (priv->rxSignalBuffer.rx_buff[i].bufptr == NULL) {
 			int j;
-			unifi_error(priv, "signal_buffer_init:Failed to Allocate shared memory for T-H signals \n");
+			unifi_error(priv, "signal_buffer_init:Failed to Allocate shared memory for T-H signals\n");
 			for (j = 0; j < i; j++) {
 				priv->rxSignalBuffer.rx_buff[j].sig_len = 0;
 				kfree(priv->rxSignalBuffer.rx_buff[j].bufptr);
@@ -389,7 +389,7 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 	}
 	priv->rx_workqueue = create_singlethread_workqueue("rx_workq");
 	if (priv->rx_workqueue == NULL) {
-		unifi_error(priv, "create_singlethread_workqueue failed \n");
+		unifi_error(priv, "create_singlethread_workqueue failed\n");
 		goto failed3;
 	}
 	INIT_WORK(&priv->rx_work_struct, rx_wq_handler);
-- 
1.7.9.5

