Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab0L3XNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 18:13:36 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64019 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab0L3XIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:08:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KjmAF8j6s/MbWLAPg5etZNLszciO+z+jB51CQp2m8LkTETEeBve/xu7YSoWH+nQrxC
         ri/TgY007bC32t+Cpx3zWcHXL2a30r4A2KHUVr7VHBrr8uxdMUIvFAm4NRPSYibcTTjc
         60bKhHN6Ie4P0MNeUHPVUBMJ7SYb6e//oyWNo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 03/15]drivers:staging:rtl8187se:r8180_hw.h Typo change diable to disable.
Date: Thu, 30 Dec 2010 15:07:52 -0800
Message-Id: <1293750484-1161-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293750484-1161-2-git-send-email-justinmattock@gmail.com>
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-2-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a typo "diable" to "disable". Please let me know if this 
is correct or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/rtl8187se/r8180_hw.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_hw.h b/drivers/staging/rtl8187se/r8180_hw.h
index 3fca144..2911d40 100644
--- a/drivers/staging/rtl8187se/r8180_hw.h
+++ b/drivers/staging/rtl8187se/r8180_hw.h
@@ -554,7 +554,7 @@
 /* by amy for power save		*/
 /* by amy for antenna			*/
 #define EEPROM_SW_REVD_OFFSET 0x3f
-/*  BIT[8-9] is for SW Antenna Diversity. Only the value EEPROM_SW_AD_ENABLE means enable, other values are diable.					*/
+/*  BIT[8-9] is for SW Antenna Diversity. Only the value EEPROM_SW_AD_ENABLE means enable, other values are disabled.					*/
 #define EEPROM_SW_AD_MASK			0x0300
 #define EEPROM_SW_AD_ENABLE			0x0100
 
-- 
1.6.5.2.180.gc5b3e

