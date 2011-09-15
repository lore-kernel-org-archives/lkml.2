Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562Ab1IOMsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:48:39 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:53345 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933473Ab1IOMsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:48:37 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 08/17] ASoC: twl6040: Fix comments for register names
Date: Thu, 15 Sep 2011 15:39:30 +0300
Message-Id: <1316090379-30760-9-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the register name strings in the comments for the
twl6040_reg table, so it is easier to search for specific
register.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl6040.c |   94 ++++++++++++++++++++++----------------------
 1 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 1f6068b..9d1f82d 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -106,53 +106,53 @@ struct twl6040_data {
  * twl6040 register cache & default register settings
  */
 static const u8 twl6040_reg[TWL6040_CACHEREGNUM] = {
-	0x00, /* not used		0x00	*/
-	0x4B, /* TWL6040_ASICID (ro)	0x01	*/
-	0x00, /* TWL6040_ASICREV (ro)	0x02	*/
-	0x00, /* TWL6040_INTID		0x03	*/
-	0x00, /* TWL6040_INTMR		0x04	*/
-	0x00, /* TWL6040_NCPCTRL	0x05	*/
-	0x00, /* TWL6040_LDOCTL		0x06	*/
-	0x60, /* TWL6040_HPPLLCTL	0x07	*/
-	0x00, /* TWL6040_LPPLLCTL	0x08	*/
-	0x4A, /* TWL6040_LPPLLDIV	0x09	*/
-	0x00, /* TWL6040_AMICBCTL	0x0A	*/
-	0x00, /* TWL6040_DMICBCTL	0x0B	*/
-	0x00, /* TWL6040_MICLCTL	0x0C	*/
-	0x00, /* TWL6040_MICRCTL	0x0D	*/
-	0x00, /* TWL6040_MICGAIN	0x0E	*/
-	0x1B, /* TWL6040_LINEGAIN	0x0F	*/
-	0x00, /* TWL6040_HSLCTL		0x10	*/
-	0x00, /* TWL6040_HSRCTL		0x11	*/
-	0x00, /* TWL6040_HSGAIN		0x12	*/
-	0x00, /* TWL6040_EARCTL		0x13	*/
-	0x00, /* TWL6040_HFLCTL		0x14	*/
-	0x00, /* TWL6040_HFLGAIN	0x15	*/
-	0x00, /* TWL6040_HFRCTL		0x16	*/
-	0x00, /* TWL6040_HFRGAIN	0x17	*/
-	0x00, /* TWL6040_VIBCTLL	0x18	*/
-	0x00, /* TWL6040_VIBDATL	0x19	*/
-	0x00, /* TWL6040_VIBCTLR	0x1A	*/
-	0x00, /* TWL6040_VIBDATR	0x1B	*/
-	0x00, /* TWL6040_HKCTL1		0x1C	*/
-	0x00, /* TWL6040_HKCTL2		0x1D	*/
-	0x00, /* TWL6040_GPOCTL		0x1E	*/
-	0x00, /* TWL6040_ALB		0x1F	*/
-	0x00, /* TWL6040_DLB		0x20	*/
-	0x00, /* not used		0x21	*/
-	0x00, /* not used		0x22	*/
-	0x00, /* not used		0x23	*/
-	0x00, /* not used		0x24	*/
-	0x00, /* not used		0x25	*/
-	0x00, /* not used		0x26	*/
-	0x00, /* not used		0x27	*/
-	0x00, /* TWL6040_TRIM1		0x28	*/
-	0x00, /* TWL6040_TRIM2		0x29	*/
-	0x00, /* TWL6040_TRIM3		0x2A	*/
-	0x00, /* TWL6040_HSOTRIM	0x2B	*/
-	0x00, /* TWL6040_HFOTRIM	0x2C	*/
-	0x09, /* TWL6040_ACCCTL		0x2D	*/
-	0x00, /* TWL6040_STATUS (ro)	0x2E	*/
+	0x00, /* not used	0x00	*/
+	0x4B, /* REG_ASICID	0x01 (ro) */
+	0x00, /* REG_ASICREV	0x02 (ro) */
+	0x00, /* REG_INTID	0x03	*/
+	0x00, /* REG_INTMR	0x04	*/
+	0x00, /* REG_NCPCTRL	0x05	*/
+	0x00, /* REG_LDOCTL	0x06	*/
+	0x60, /* REG_HPPLLCTL	0x07	*/
+	0x00, /* REG_LPPLLCTL	0x08	*/
+	0x4A, /* REG_LPPLLDIV	0x09	*/
+	0x00, /* REG_AMICBCTL	0x0A	*/
+	0x00, /* REG_DMICBCTL	0x0B	*/
+	0x00, /* REG_MICLCTL	0x0C	*/
+	0x00, /* REG_MICRCTL	0x0D	*/
+	0x00, /* REG_MICGAIN	0x0E	*/
+	0x1B, /* REG_LINEGAIN	0x0F	*/
+	0x00, /* REG_HSLCTL	0x10	*/
+	0x00, /* REG_HSRCTL	0x11	*/
+	0x00, /* REG_HSGAIN	0x12	*/
+	0x00, /* REG_EARCTL	0x13	*/
+	0x00, /* REG_HFLCTL	0x14	*/
+	0x00, /* REG_HFLGAIN	0x15	*/
+	0x00, /* REG_HFRCTL	0x16	*/
+	0x00, /* REG_HFRGAIN	0x17	*/
+	0x00, /* REG_VIBCTLL	0x18	*/
+	0x00, /* REG_VIBDATL	0x19	*/
+	0x00, /* REG_VIBCTLR	0x1A	*/
+	0x00, /* REG_VIBDATR	0x1B	*/
+	0x00, /* REG_HKCTL1	0x1C	*/
+	0x00, /* REG_HKCTL2	0x1D	*/
+	0x00, /* REG_GPOCTL	0x1E	*/
+	0x00, /* REG_ALB	0x1F	*/
+	0x00, /* REG_DLB	0x20	*/
+	0x00, /* not used	0x21	*/
+	0x00, /* not used	0x22	*/
+	0x00, /* not used	0x23	*/
+	0x00, /* not used	0x24	*/
+	0x00, /* not used	0x25	*/
+	0x00, /* not used	0x26	*/
+	0x00, /* not used	0x27	*/
+	0x00, /* REG_TRIM1	0x28	*/
+	0x00, /* REG_TRIM2	0x29	*/
+	0x00, /* REG_TRIM3	0x2A	*/
+	0x00, /* REG_HSOTRIM	0x2B	*/
+	0x00, /* REG_HFOTRIM	0x2C	*/
+	0x09, /* REG_ACCCTL	0x2D	*/
+	0x00, /* REG_STATUS	0x2E (ro) */
 };
 
 /* List of registers to be restored after power up */
-- 
1.7.6.1

