Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab0L3XI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 18:08:29 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57500 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab0L3XIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:08:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BF0nad3+32OYnhAEeuOOYxyWLo6CUKSm3BNJ+9aJlFqytI0TZeRzsKHLRoo0nTJv8l
         hsbw2NCaLtEUGH6uzc8nmW856UZgVtKEG/thnBBi9c7dJgdWj2Ic2Kp7I3Hj/PhXOsk0
         xXjhsF3BmwO88UuzR59Jy6gqRymzLO3ew4xpU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 06/15]drivers:staging:xgifb:vb_setmode.c Typo change diable to disable.
Date: Thu, 30 Dec 2010 15:07:55 -0800
Message-Id: <1293750484-1161-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293750484-1161-5-git-send-email-justinmattock@gmail.com>
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-2-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-3-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-4-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-5-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a typo "diable" to "disable". Please let me know if this 
is correct or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/xgifb/vb_setmode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 7016fdd..fb49641 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -1920,7 +1920,7 @@ void XGI_SetCRT1FIFO(unsigned short ModeNo,
 
 	data = XGINew_GetReg1(pVBInfo->P3c4, 0x3D);
 	data &= 0xfe;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x3D, data); /* diable auto-threshold */
+	XGINew_SetReg1(pVBInfo->P3c4, 0x3D, data); /* disable auto-threshold */
 
 	if (ModeNo > 0x13) {
 		XGINew_SetReg1(pVBInfo->P3c4, 0x08, 0x34);
-- 
1.6.5.2.180.gc5b3e

