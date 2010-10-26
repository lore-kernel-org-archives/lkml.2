Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375Ab0JZT6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:58:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39499 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760361Ab0JZT6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:58:06 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: gregkh@suse.de
Cc: trivial@kernel.de, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging/trivial: fix typos concerning "controller"
Date: Tue, 26 Oct 2010 21:57:53 +0200
Message-Id: <1288123073-22470-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1288123073-22470-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1288123073-22470-1-git-send-email-u.kleine-koenig@pengutronix.de>
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
 .../staging/comedi/drivers/addi-data/addi_common.c |    4 ++--
 .../comedi/drivers/addi-data/hwdrv_APCI1710.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |    2 +-
 drivers/staging/rtl8192u/r8192U_core.c             |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.c b/drivers/staging/comedi/drivers/addi-data/addi_common.c
index 93d7c05..76f2483 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.c
@@ -2710,10 +2710,10 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			} else {
 				outl(0x83838383, devpriv->i_IobaseAmcc + 0x60);
 			}
-			/*  Enable the interrupt for the controler */
+			/*  Enable the interrupt for the controller */
 			dw_Dummy = inl(devpriv->i_IobaseAmcc + 0x38);
 			outl(dw_Dummy | 0x2000, devpriv->i_IobaseAmcc + 0x38);
-			printk("\nEnable the interrupt for the controler");
+			printk("\nEnable the interrupt for the controller");
 		}
 		printk("\nRead Eeprom");
 		i_EepromReadMainHeader(io_addr[0], this_board->pc_EepromChip,
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
index 912bc0f..a76ed25 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
@@ -225,7 +225,7 @@ int i_APCI1710_Reset(struct comedi_device *dev)
 
 	devpriv->s_BoardInfos.b_BoardVersion = 1;
 
-	/*  Enable the interrupt for the controler */
+	/*  Enable the interrupt for the controller */
 	dw_Dummy = inl(devpriv->s_BoardInfos.ui_Address + 0x38);
 	outl(dw_Dummy | 0x2000, devpriv->s_BoardInfos.ui_Address + 0x38);
 
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
index b943a06..a93e234 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
@@ -3011,7 +3011,7 @@ int i_APCI3200_Reset(struct comedi_device *dev)
 
 	outl(0x83838383, devpriv->i_IobaseAmcc + 0x60);
 
-	/*  Enable the interrupt for the controler */
+	/*  Enable the interrupt for the controller */
 	dw_Dummy = inl(devpriv->i_IobaseAmcc + 0x38);
 	outl(dw_Dummy | 0x2000, devpriv->i_IobaseAmcc + 0x38);
 	outl(0, devpriv->i_IobaseAddon);	/* Resets the output */
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 494f180..4cc7b41 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -1507,7 +1507,7 @@ static void rtl8192_tx_isr(struct urb *tx_urb)
 	{
 		//
 		// Handle HW Beacon:
-		// We had transfer our beacon frame to host controler at this moment.
+		// We had transfer our beacon frame to host controller at this moment.
 		//
 		//
 		// Caution:
-- 
1.7.2.3

