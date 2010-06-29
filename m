Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab0F2KRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:17:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:47959 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab0F2KQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:16:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RBMmCHpJx4QoACdf+YgSBS8P7uGLno0uYwvwGDqD5bnpvkjfa6GPreGcZMNtdMS4mq
         EKUrXbpm0s+ZWizTi01nbbVAnZE+szme/Gv3+76WR/6pFthwuGj1L4U/yox/CheACj6F
         xj5+cBp7JE8bKcb1rDI9W4wVuNoLkm9Zn+91s=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 18/25] rtmp_timer: remove casts from void*
Date: Tue, 29 Jun 2010 14:16:04 +0400
Message-Id: <1277806565-31316-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/rt2860/common/rtmp_timer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rt2860/common/rtmp_timer.c b/drivers/staging/rt2860/common/rtmp_timer.c
index 42e47d9..ab52090 100644
--- a/drivers/staging/rt2860/common/rtmp_timer.c
+++ b/drivers/staging/rt2860/common/rtmp_timer.c
@@ -143,8 +143,8 @@ int RtmpTimerQThread(IN void *Context)
 	struct rt_rtmp_os_task *pTask;
 	struct rt_rtmp_adapter *pAd;
 
-	pTask = (struct rt_rtmp_os_task *)Context;
-	pAd = (struct rt_rtmp_adapter *)pTask->priv;
+	pTask = Context;
+	pAd = pTask->priv;
 
 	RtmpOSTaskCustomize(pTask);
 
-- 
1.7.0.4

