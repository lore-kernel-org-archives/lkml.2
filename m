Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab2GMUW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 16:22:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32980 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab2GMUWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 16:22:25 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 3/3] staging/vt6656: cleanup coding style in vResetCommandTimer
Date: Sat, 14 Jul 2012 02:07:18 +0545
Message-Id: <1342210938-9164-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the following fixes...

removed spaces at start of a line and used tabs

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/vt6656/wcmd.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index c9de937..9d2caa8 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -1254,21 +1254,21 @@ static BOOL s_bClearBSSID_SCAN(void *hDeviceContext)
 //mike add:reset command timer
 void vResetCommandTimer(void *hDeviceContext)
 {
-  PSDevice        pDevice = (PSDevice)hDeviceContext;
+	PSDevice pDevice = (PSDevice)hDeviceContext;
 
-  //delete timer
-      del_timer(&pDevice->sTimerCommand);
-  //init timer
-      init_timer(&pDevice->sTimerCommand);
-    pDevice->sTimerCommand.data = (unsigned long)pDevice;
-    pDevice->sTimerCommand.function = (TimerFunction)vRunCommand;
-    pDevice->sTimerCommand.expires = RUN_AT(HZ);
-    pDevice->cbFreeCmdQueue = CMD_Q_SIZE;
-    pDevice->uCmdDequeueIdx = 0;
-    pDevice->uCmdEnqueueIdx = 0;
-    pDevice->eCommandState = WLAN_CMD_IDLE;
-    pDevice->bCmdRunning = FALSE;
-    pDevice->bCmdClear = FALSE;
+	//delete timer
+	del_timer(&pDevice->sTimerCommand);
+	//init timer
+	init_timer(&pDevice->sTimerCommand);
+	pDevice->sTimerCommand.data = (unsigned long)pDevice;
+	pDevice->sTimerCommand.function = (TimerFunction)vRunCommand;
+	pDevice->sTimerCommand.expires = RUN_AT(HZ);
+	pDevice->cbFreeCmdQueue = CMD_Q_SIZE;
+	pDevice->uCmdDequeueIdx = 0;
+	pDevice->uCmdEnqueueIdx = 0;
+	pDevice->eCommandState = WLAN_CMD_IDLE;
+	pDevice->bCmdRunning = FALSE;
+	pDevice->bCmdClear = FALSE;
 }
 
 void BSSvSecondTxData(void *hDeviceContext)
-- 
1.7.9.5

