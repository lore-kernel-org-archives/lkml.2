Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0F2KRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:17:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33660 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab0F2KQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pdjRiFy8tGoJmClFkmJkDbQTZhcDebxqEqV0LVdMFOwEOeksQRX849r/8uW1ScKxug
         17iFy55tF/o0DbhcY9XKDsBasZJYo18h55zTB52nDydrkkZJNktjjhGsxkM91f7dxI+O
         i7jJ2fb/lEfyjUAbsKHcwEbYuHg0mM9dKitDY=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       =?UTF-8?q?Sebastian=20Dalfu=C3=9F?= <sd@sedf.de>,
       Jeff Mahoney <jeffm@suse.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 19/25] rt_linux: remove casts from void*
Date: Tue, 29 Jun 2010 14:16:08 +0400
Message-Id: <1277806569-31350-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/rt2860/rt_linux.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_linux.c
index 0029b2d..6536965 100644
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -1015,7 +1015,7 @@ int RtmpOSTaskKill(struct rt_rtmp_os_task *pTask)
 	struct rt_rtmp_adapter *pAd;
 	int ret = NDIS_STATUS_FAILURE;
 
-	pAd = (struct rt_rtmp_adapter *)pTask->priv;
+	pAd = pTask->priv;
 
 #ifdef KTHREAD_SUPPORT
 	if (pTask->kthread_task) {
-- 
1.7.0.4

