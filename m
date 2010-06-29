Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab0F2KQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:16:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:3013 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab0F2KQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UrX55rcPUGHYgasUhdppelSJi3WpthcCXS5A6ZBaQdHrzJRwnEQuHdWzoA59HntUeD
         gZ6h0hRfxysCkh1E+QK42pAL00kaUOl4QDWefaHQaSEYm9+S2mAxG1T8n7vWc1eK/zdY
         aUBu9crxz0P1A3a52+i0+Ml1Y/JrqfkZvwJ/s=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Simon Horman <horms@verge.net.au>,
       Nobhiro KUSUNO <n-kusuno@fc4.so-net.ne.jp>,
       =?UTF-8?q?Sebastian=20Dalfu=C3=9F?= <sd@sedf.de>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 20/25] usb_main_dev: remove casts from void*
Date: Tue, 29 Jun 2010 14:16:12 +0400
Message-Id: <1277806573-31384-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/rt2860/usb_main_dev.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rt2860/usb_main_dev.c b/drivers/staging/rt2860/usb_main_dev.c
index b740662..40eab25 100644
--- a/drivers/staging/rt2860/usb_main_dev.c
+++ b/drivers/staging/rt2860/usb_main_dev.c
@@ -421,8 +421,8 @@ int MlmeThread(IN void *Context)
 	int status;
 	status = 0;
 
-	pTask = (struct rt_rtmp_os_task *)Context;
-	pAd = (struct rt_rtmp_adapter *)pTask->priv;
+	pTask = Context;
+	pAd = pTask->priv;
 
 	RtmpOSTaskCustomize(pTask);
 
@@ -490,8 +490,8 @@ int RTUSBCmdThread(IN void *Context)
 	int status;
 	status = 0;
 
-	pTask = (struct rt_rtmp_os_task *)Context;
-	pAd = (struct rt_rtmp_adapter *)pTask->priv;
+	pTask = Context;
+	pAd = pTask->priv;
 
 	RtmpOSTaskCustomize(pTask);
 
-- 
1.7.0.4

