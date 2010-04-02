Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab0DBJ5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 05:57:16 -0400
Received: from 84-21.comp.nus.edu.sg ([137.132.84.21]:34376 "EHLO
	postfix1.comp.nus.edu.sg" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754869Ab0DBJ5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 05:57:06 -0400
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Apr 2010 05:57:05 EDT
Date: Fri, 2 Apr 2010 17:49:17 +0800 (SGT)
From: NG KIAN YONG <ngky@comp.nus.edu.sg>
To: gregkh@suse.de, lieb@canonical.com, forest@alittletooquiet.net,
       andre.goddard@gmail.com
cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] Staging: vt6655: fix brace coding style issue in ioctl.c
Message-ID: <Pine.SOC.4.64.1004021738200.6970@sunfire0.comp.nus.edu.sg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f7413706dd9b5fc217aa738bb48d36b46ab65a98 Mon Sep 17 00:00:00 2001
From: Ng Kian Yong <ngky@comp.nus.edu.sg>
Date: Fri, 2 Apr 2010 17:20:06 +0800
Subject: [PATCH 1/1] Staging: vt6655: fix brace coding style issue in ioctl.c
  This is a patch to the ioctl.c file that fixes up a brace warning found by the checkpatch.pl tool
  Signed-off-by: Ng Kian Yong <ngky@comp.nus.edu.sg>

---
  drivers/staging/vt6655/ioctl.c |   12 ++++++------
  1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6655/ioctl.c b/drivers/staging/vt6655/ioctl.c
index d9a5fd2..a15b953 100644
--- a/drivers/staging/vt6655/ioctl.c
+++ b/drivers/staging/vt6655/ioctl.c
@@ -54,14 +54,14 @@ static int          msglevel                =MSG_LEVEL_INFO;

  /*---------------------  Export Variables  --------------------------*/

-int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
-
-	PSCmdRequest        pReq = (PSCmdRequest)rq;
+int private_ioctl(PSDevice pDevice, struct ifreq *rq)
+{
+    PSCmdRequest        pReq = (PSCmdRequest)rq;
      PSMgmtObject        pMgmt = pDevice->pMgmt;
-	int 		        result = 0;
+    int                 result = 0;
      PWLAN_IE_SSID       pItemSSID;
      SCmdBSSJoin         sJoinCmd;
-    SCmdZoneTypeSet  sZoneTypeCmd;
+    SCmdZoneTypeSet     sZoneTypeCmd;
      SCmdScan            sScanCmd;
      SCmdStartAP         sStartAPCmd;
      SCmdSetWEP          sWEPCmd;
@@ -83,7 +83,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {

      pReq->wResult = 0;

-    switch(pReq->wCmdCode) {
+    switch (pReq->wCmdCode) {

      case WLAN_CMD_BSS_SCAN:

-- 
1.6.6.1


