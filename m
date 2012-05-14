Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab2ENOZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 10:25:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37378 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab2ENOZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 10:25:51 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: gregkh@linuxfoundation.org
Cc: edwin_rong@realsil.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH NEXT]staging: "rts5139" Fix typos.
Date: Mon, 14 May 2012 07:25:35 -0700
Message-Id: <1337005535-27800-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch fixes some typos found while reading through rts5139.

 drivers/staging/rts5139/ms.c               |    2 +-
 drivers/staging/rts5139/ms_mg.c            |    2 +-
 drivers/staging/rts5139/rts51x_chip.h      |   10 +++++-----
 drivers/staging/rts5139/rts51x_transport.c |    2 +-
 drivers/staging/rts5139/sd.c               |    6 +++---
 drivers/staging/rts5139/xd.c               |    2 +-
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rts5139/ms.c b/drivers/staging/rts5139/ms.c
index 02aad2d..512f9f9 100644
--- a/drivers/staging/rts5139/ms.c
+++ b/drivers/staging/rts5139/ms.c
@@ -3149,7 +3149,7 @@ Fail:
 		TRACE_RET(chip, STATUS_FAIL);
 
 	sec_cnt = chip->rsp_buf[0];
-	RTS51X_DEBUGP("%d pages need be trasferred, %d pages remained\n",
+	RTS51X_DEBUGP("%d pages need be transferred, %d pages remained\n",
 		       (int)page_cnt, (int)sec_cnt);
 	page_addr = start_page + (page_cnt - sec_cnt);
 
diff --git a/drivers/staging/rts5139/ms_mg.c b/drivers/staging/rts5139/ms_mg.c
index 154b523..fcda587 100644
--- a/drivers/staging/rts5139/ms_mg.c
+++ b/drivers/staging/rts5139/ms_mg.c
@@ -444,7 +444,7 @@ int mg_rsp(struct scsi_cmnd *srb, struct rts51x_chip *chip)
   *
   * Since the extra 4 bytes data is just only a prefix to original data
   * that read from medium, so that the 4-byte data pushed into Ring buffer
-  * precedes data tramsinssion from medium to Ring buffer by DMA mechanisim
+  * precedes data transmission from medium to Ring buffer by DMA mechanism
   * in order to get maximum performance and minimum code size simultaneously.
   */
 int mg_get_ICV(struct scsi_cmnd *srb, struct rts51x_chip *chip)
diff --git a/drivers/staging/rts5139/rts51x_chip.h b/drivers/staging/rts5139/rts51x_chip.h
index 13fc2a4..cd56012 100644
--- a/drivers/staging/rts5139/rts51x_chip.h
+++ b/drivers/staging/rts5139/rts51x_chip.h
@@ -222,7 +222,7 @@ struct trace_msg_t {
 #define HARDWARE_ERR            0x04	/* hardware error                   */
 #define ILGAL_REQ               0x05	/* CDB/parameter/identify msg error */
 #define UNIT_ATTENTION          0x06	/* unit attention condition occur   */
-#define DAT_PRTCT               0x07	/* read/write is desable            */
+#define DAT_PRTCT               0x07	/* read/write is disable            */
 #define BLNC_CHK                0x08	/* find blank/DOF in read           */
 					/* write to unblank area            */
 #define CPY_ABRT                0x0a	/* Copy/Compare/Copy&Verify illgal  */
@@ -243,7 +243,7 @@ struct trace_msg_t {
 #define DEF_ERR                 0x71	/* specific command error           */
 
 /*---- sense key Infomation ----*/
-#define SNSKEYINFO_LEN          3	/* length of sense key infomation   */
+#define SNSKEYINFO_LEN          3	/* length of sense key information   */
 
 #define SKSV                    0x80
 #define CDB_ILLEGAL             0x40
@@ -298,11 +298,11 @@ struct sense_data_t {
 	/* bit3-0 : sense key              */
 	unsigned char info[4];	/* infomation                       */
 	unsigned char ad_sense_len;	/* additional sense data length     */
-	unsigned char cmd_info[4];	/* command specific infomation      */
+	unsigned char cmd_info[4];	/* command specific information      */
 	unsigned char asc;	/* ASC                              */
 	unsigned char ascq;	/* ASCQ                             */
 	unsigned char rfu;	/* FRU                              */
-	unsigned char sns_key_info[3];	/* sense key specific infomation    */
+	unsigned char sns_key_info[3];	/* sense key specific information    */
 };
 
 /* sd_ctl bit map */
@@ -405,7 +405,7 @@ struct rts51x_option {
 	u8 ddr50_rx_phase;
 	u8 sdr50_tx_phase;
 	u8 sdr50_rx_phase;
-	/* used to enable select sdr50 tx phase according to  proportion. */
+	/* used to enable select sdr50 tx phase according to proportion. */
 	u8 sdr50_phase_sel;
 	u8 ms_errreg_fix;
 	u8 reset_mmc_first;
diff --git a/drivers/staging/rts5139/rts51x_transport.c b/drivers/staging/rts5139/rts51x_transport.c
index da9c83b..8faae9a 100644
--- a/drivers/staging/rts5139/rts51x_transport.c
+++ b/drivers/staging/rts5139/rts51x_transport.c
@@ -630,7 +630,7 @@ int rts51x_sg_wait(struct usb_sg_request *io, int timeout)
 		 */
 		spin_unlock_irq(&io->lock);
 		switch (retval) {
-			/* maybe we retrying will recover */
+			/* maybe the retry will recover */
 		case -ENXIO:	/* hc didn't queue this one */
 		case -EAGAIN:
 		case -ENOMEM:
diff --git a/drivers/staging/rts5139/sd.c b/drivers/staging/rts5139/sd.c
index d5dd2f9..c9fa5fb 100644
--- a/drivers/staging/rts5139/sd.c
+++ b/drivers/staging/rts5139/sd.c
@@ -2182,7 +2182,7 @@ RTY_CMD55:
 	sd_card->sd_addr += (u32) rsp[2] << 16;
 
 	/* Get CSD register for Calculating Timing,Capacity,
-	 * Check CSD to determaine as if this is the SD ROM card */
+	 * Check CSD to determine as if this is the SD ROM card */
 	retval = sd_check_csd(chip, 1);
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, retval);
@@ -2745,7 +2745,7 @@ RTY_MMC_RST:
 		TRACE_RET(chip, retval);
 
 	/* Get CSD register for Calculating Timing,Capacity
-	 * Check CSD to determaine as if this is the SD ROM card */
+	 * Check CSD to determine as if this is the SD ROM card */
 	retval = sd_check_csd(chip, 1);
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, retval);
@@ -3346,7 +3346,7 @@ int release_sd_card(struct rts51x_chip *chip)
 	struct sd_info *sd_card = &(chip->sd_card);
 	int retval;
 
-	RTS51X_DEBUGP("elease_sd_card\n");
+	RTS51X_DEBUGP("release_sd_card\n");
 
 	chip->card_ready &= ~SD_CARD;
 	chip->card_fail &= ~SD_CARD;
diff --git a/drivers/staging/rts5139/xd.c b/drivers/staging/rts5139/xd.c
index 5820605..f54d332 100644
--- a/drivers/staging/rts5139/xd.c
+++ b/drivers/staging/rts5139/xd.c
@@ -2232,7 +2232,7 @@ int release_xd_card(struct rts51x_chip *chip)
 	struct xd_info *xd_card = &(chip->xd_card);
 	int retval;
 
-	RTS51X_DEBUGP("elease_xd_card\n");
+	RTS51X_DEBUGP("release_xd_card\n");
 
 	chip->card_ready &= ~XD_CARD;
 	chip->card_fail &= ~XD_CARD;
-- 
1.7.5.4

