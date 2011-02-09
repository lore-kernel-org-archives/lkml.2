Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1BIKHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:07:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46665 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab1BIKHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:07:54 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/10] trivial: fix typos concerning "access"
Date: Wed,  9 Feb 2011 11:07:33 +0100
Message-Id: <1297246062-23777-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arm/mach-omap2/control.h                  |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    8 ++++----
 drivers/target/target_core_transport.c         |    2 +-
 drivers/usb/gadget/mv_udc_core.c               |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap2/control.h b/arch/arm/mach-omap2/control.h
index f0629ae..a1981e9 100644
--- a/arch/arm/mach-omap2/control.h
+++ b/arch/arm/mach-omap2/control.h
@@ -233,7 +233,7 @@
 #define OMAP343X_CONTROL_WKUP_DEBOBS3 (OMAP343X_CONTROL_GENERAL_WKUP + 0x014)
 #define OMAP343X_CONTROL_WKUP_DEBOBS4 (OMAP343X_CONTROL_GENERAL_WKUP + 0x018)
 
-/* 36xx-only RTA - Retention till Accesss control registers and bits */
+/* 36xx-only RTA - Retention till Access control registers and bits */
 #define OMAP36XX_CONTROL_MEM_RTA_CTRL	0x40C
 #define OMAP36XX_RTA_DISABLE		0x0
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 4819747..7b70e51 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3329,26 +3329,26 @@ static int ar9300_eeprom_restore_internal(struct ath_hw *ah,
 	else
 		cptr = AR9300_BASE_ADDR;
 	ath_dbg(common, ATH_DBG_EEPROM,
-		"Trying EEPROM accesss at Address 0x%04x\n", cptr);
+		"Trying EEPROM access at Address 0x%04x\n", cptr);
 	if (ar9300_check_eeprom_header(ah, read, cptr))
 		goto found;
 
 	cptr = AR9300_BASE_ADDR_512;
 	ath_dbg(common, ATH_DBG_EEPROM,
-		"Trying EEPROM accesss at Address 0x%04x\n", cptr);
+		"Trying EEPROM access at Address 0x%04x\n", cptr);
 	if (ar9300_check_eeprom_header(ah, read, cptr))
 		goto found;
 
 	read = ar9300_read_otp;
 	cptr = AR9300_BASE_ADDR;
 	ath_dbg(common, ATH_DBG_EEPROM,
-		"Trying OTP accesss at Address 0x%04x\n", cptr);
+		"Trying OTP access at Address 0x%04x\n", cptr);
 	if (ar9300_check_eeprom_header(ah, read, cptr))
 		goto found;
 
 	cptr = AR9300_BASE_ADDR_512;
 	ath_dbg(common, ATH_DBG_EEPROM,
-		"Trying OTP accesss at Address 0x%04x\n", cptr);
+		"Trying OTP access at Address 0x%04x\n", cptr);
 	if (ar9300_check_eeprom_header(ah, read, cptr))
 		goto found;
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 28b6292..40328e6 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3087,7 +3087,7 @@ static int transport_generic_cmd_sequencer(
 	if (ret != 0) {
 		cmd->transport_wait_for_tasks = &transport_nop_wait_for_tasks;
 		/*
-		 * Set SCSI additional sense code (ASC) to 'LUN Not Accessable';
+		 * Set SCSI additional sense code (ASC) to 'LUN Not Accessible';
 		 * The ALUA additional sense code qualifier (ASCQ) is determined
 		 * by the ALUA primary or secondary access state..
 		 */
diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
index d5468a7..afe907d 100644
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -1974,7 +1974,7 @@ int mv_udc_probe(struct platform_device *dev)
 		goto error;
 	}
 
-	/* we will acces controller register, so enable the clk */
+	/* we will access controller register, so enable the clk */
 	clk_enable(udc->clk);
 	retval = mv_udc_phy_init(udc->phy_regs);
 	if (retval) {
-- 
1.7.2.3

