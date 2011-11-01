Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab1KAKom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 06:44:42 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:35328 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab1KAKol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 06:44:41 -0400
From: Ciaran McCormick <ciaranmccormick@gmail.com>
To: gregkh@suse.de, shemminger@vyatta.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ciaran McCormick <ciaranmccormick@gmail.com>
Subject: [PATCH] Stageing: bcm: fixed spacing coding style in led_control.c
Date: Tue,  1 Nov 2011 10:44:19 +0000
Message-Id: <1320144259-22339-1-git-send-email-ciaranmccormick@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Signed-off-by: Ciaran McCormick <ciaranmccormick@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/bcm/led_control.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/bcm/led_control.c b/drivers/staging/bcm/led_control.c
index 16e939f..28c3382 100644
--- a/drivers/staging/bcm/led_control.c
+++ b/drivers/staging/bcm/led_control.c
@@ -5,8 +5,8 @@
 
 static B_UINT16 CFG_CalculateChecksum(B_UINT8 *pu8Buffer, B_UINT32 u32Size)
 {
-	B_UINT16 	u16CheckSum=0;
-	while(u32Size--) {
+	B_UINT16	u16CheckSum = 0;
+	while (u32Size--) {
 		u16CheckSum += (B_UINT8)~(*pu8Buffer);
 	    pu8Buffer++;
 	}
@@ -16,7 +16,7 @@ BOOLEAN IsReqGpioIsLedInNVM(PMINI_ADAPTER Adapter, UINT gpios)
 {
 	INT Status ;
 	Status = (Adapter->gpioBitMap & gpios) ^ gpios ;
-	if(Status)
+	if (Status)
 		return FALSE;
 	else
 		return TRUE;
-- 
1.7.5.4

