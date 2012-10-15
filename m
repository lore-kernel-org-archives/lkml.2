Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab2JORZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:25:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59400 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab2JORZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:25:00 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 07/14] staging: csr: Fixed indentation mistakes on io.c
Date: Tue, 16 Oct 2012 02:24:26 +0900
Message-Id: <1350321868-2613-7-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350321868-2613-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350321868-2613-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just fixed a few indentation mistakes (adding one more whitespace)
from the code.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/io.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/csr/io.c b/drivers/staging/csr/io.c
index 204d307..cecc1df 100644
--- a/drivers/staging/csr/io.c
+++ b/drivers/staging/csr/io.c
@@ -120,9 +120,9 @@ static void signal_buffer_free(unifi_priv_t * priv, int size)
 	int i;
 
 	for (i = 0; i < size; i++) {
-		 priv->rxSignalBuffer.rx_buff[i].sig_len = 0;
-		 kfree(priv->rxSignalBuffer.rx_buff[i].bufptr);
-		 priv->rxSignalBuffer.rx_buff[i].bufptr = NULL;
+		priv->rxSignalBuffer.rx_buff[i].sig_len = 0;
+		kfree(priv->rxSignalBuffer.rx_buff[i].bufptr);
+		priv->rxSignalBuffer.rx_buff[i].bufptr = NULL;
 	}
 }
 #endif
-- 
1.7.9.5

