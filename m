Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966325Ab2EOSeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:34:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49416 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964946Ab2EOSeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:34:17 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] staging:rtl8712: Fix typo in rtl871x_io.h
Date: Wed, 16 May 2012 03:34:19 +0900
Message-Id: <1337106859-13835-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.10.2.520.g6a4a482
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo "padater" to "padapter" in rtl871x_io.h

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/rtl8712/rtl871x_io.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8712/rtl871x_io.h b/drivers/staging/rtl8712/rtl871x_io.h
index d3d8727..dc23395 100644
--- a/drivers/staging/rtl8712/rtl871x_io.h
+++ b/drivers/staging/rtl8712/rtl871x_io.h
@@ -117,7 +117,7 @@ struct io_req {
 	u32	command;
 	u32	status;
 	u8	*pbuf;
-	void (*_async_io_callback)(struct _adapter *padater,
+	void (*_async_io_callback)(struct _adapter *padapter,
 				   struct io_req *pio_req, u8 *cnxt);
 	u8 *cnxt;
 };
-- 
1.7.10.2.520.g6a4a482

