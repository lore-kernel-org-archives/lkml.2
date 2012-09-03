Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab2ICPGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 11:06:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45383 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab2ICPGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 11:06:13 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]NEXT:staging "winbond" Fix typos.
Date: Mon,  3 Sep 2012 08:06:02 -0700
Message-Id: <1346684762-8008-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch fixes typos found while reading through staging "winbond".

 drivers/staging/winbond/localpara.h       |    4 ++--
 drivers/staging/winbond/mds.c             |    2 +-
 drivers/staging/winbond/mto.c             |    2 +-
 drivers/staging/winbond/phy_calibration.c |   14 +++++++-------
 drivers/staging/winbond/reg.c             |    2 +-
 drivers/staging/winbond/sme_api.h         |    2 +-
 drivers/staging/winbond/wb35reg.c         |    4 ++--
 drivers/staging/winbond/wb35tx.c          |    8 ++++----
 drivers/staging/winbond/wb35tx_s.h        |    2 +-
 9 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/winbond/localpara.h b/drivers/staging/winbond/localpara.h
index d798057..84effc4 100644
--- a/drivers/staging/winbond/localpara.h
+++ b/drivers/staging/winbond/localpara.h
@@ -137,7 +137,7 @@ struct wb_local_para {
 	u8	iPowerSaveMode; /* 0 indicates on, 1 indicates off */
 	u8	ATIMmode;
 	u8	ExcludeUnencrypted;
-	/* Unit ime count for the decision to enter PS mode */
+	/* Unit time count for the decision to enter PS mode */
 	u16	CheckCountForPS;
 	u8	boHasTxActivity;/* tx activity has occurred */
 	u8	boMacPsValid;	/* Power save mode obtained from H/W is valid or not */
@@ -187,7 +187,7 @@ struct wb_local_para {
 	u8	reserved7[3];
 
 	struct	chan_info CurrentChan;	/* Current channel no. and channel band. It may be changed by scanning. */
-	u8	boHandover;		/* Roaming, Hnadover to other AP. */
+	u8	boHandover;		/* Roaming, Handover to other AP. */
 	u8	boCCAbusy;
 
 	u16	CWMax;			/* It may not be the real value that H/W used */
diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index c9f0e8f..1b8b8ac 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -569,7 +569,7 @@ Mds_SendComplete(struct wbsoft_priv *adapter, struct T02_descriptor *pT02)
 	unsigned char	SendOK = true;
 	u8	RetryCount, TxRate;
 
-	if (pT02->T02_IgnoreResult) /* Don't care the result */
+	if (pT02->T02_IgnoreResult) /* Don't care about the result */
 		return;
 	if (pT02->T02_IsLastMpdu) {
 		/* TODO: DTO -- get the retry count and fragment count */
diff --git a/drivers/staging/winbond/mto.c b/drivers/staging/winbond/mto.c
index 1b52ebd..560c0ab 100644
--- a/drivers/staging/winbond/mto.c
+++ b/drivers/staging/winbond/mto.c
@@ -23,7 +23,7 @@
 #include "core.h"
 
 /* Declare SQ3 to rate and fragmentation threshold table */
-/* Declare fragmentation thresholds table */
+/* Declare fragmentation threshold table */
 #define MTO_MAX_FRAG_TH_LEVELS		5
 #define MTO_MAX_DATA_RATE_LEVELS	12
 
diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
index 77a3fff..cabae34 100644
--- a/drivers/staging/winbond/phy_calibration.c
+++ b/drivers/staging/winbond/phy_calibration.c
@@ -399,7 +399,7 @@ void _rxadc_dc_offset_cancellation_winbond(struct hw_data *phw_data, u32 frequen
 	val |= MASK_ADC_DC_CAL_STR;
 	hw_set_dxx_reg(phw_data, REG_MODE_CTRL, val);
 
-	/* e. The result are shown in "adc_dc_cal_i[8:0] and adc_dc_cal_q[8:0]" */
+	/* e. The results are shown in "adc_dc_cal_i[8:0] and adc_dc_cal_q[8:0]" */
 #ifdef _DEBUG
 	hw_get_dxx_reg(phw_data, REG_OFFSET_READ, &val);
 	PHY_DEBUG(("[CAL]    REG_OFFSET_READ = 0x%08X\n", val));
@@ -720,7 +720,7 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 		for (capture_time = 0; capture_time < 10; capture_time++) {
 			/*
 			 * a. Set iqcal_mode[1:0] to 0x2 and set "calib_start" to 0x1 to
-			 *    enable "IQ alibration Mode II"
+			 *    enable "IQ calibration Mode II"
 			 */
 			reg_mode_ctrl &= ~(MASK_IQCAL_TONE_SEL|MASK_IQCAL_MODE);
 			reg_mode_ctrl &= ~MASK_IQCAL_MODE;
@@ -750,7 +750,7 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 
 			/*
 			 * d. Set iqcal_mode[1:0] to 0x3 and set "calib_start" to 0x1 to
-			 *    enable "IQ alibration Mode II"
+			 *    enable "IQ calibration Mode II"
 			 */
 			/* hw_get_dxx_reg(phw_data, REG_MODE_CTRL, &val); */
 			hw_get_dxx_reg(phw_data, REG_MODE_CTRL, &reg_mode_ctrl);
@@ -980,7 +980,7 @@ void _tx_iq_calibration_winbond(struct hw_data *phw_data)
 	phy_set_rf_data(phw_data, 0, (0<<24)|0xFDF1C0);
 	/* ; [BB-chip]: Calibration (6f).Send test pattern */
 	/* ; [BB-chip]: Calibration (6g). Search RXGCL optimal value */
-	/* ; [BB-chip]: Calibration (6h). Caculate TX-path IQ imbalance and setting TX path IQ compensation table */
+	/* ; [BB-chip]: Calibration (6h). Calculate TX-path IQ imbalance and setting TX path IQ compensation table */
 	/* phy_set_rf_data(phw_data, 3, (3<<24)|0x025586); */
 
 	msleep(30); /* 20060612.1.a 30ms delay. Add the follow 2 lines */
@@ -1373,7 +1373,7 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 /***************************************************************/
 void _rx_iq_calibration_winbond(struct hw_data *phw_data, u32 frequency)
 {
-/* figo 20050523 marked this flag for can't compile for relesase */
+/* figo 20050523 marked this flag for can't compile for release */
 #ifdef _DEBUG
 	s32     rx_cal_reg[4];
 	u32     val;
@@ -1397,7 +1397,7 @@ void _rx_iq_calibration_winbond(struct hw_data *phw_data, u32 frequency)
 
 	/*  ; [BB-chip]: Calibration (7f). Send test pattern */
 	/*	; [BB-chip]: Calibration (7g). Search RXGCL optimal value */
-	/*	; [BB-chip]: Calibration (7h). Caculate RX-path IQ imbalance and setting RX path IQ compensation table */
+	/*	; [BB-chip]: Calibration (7h). Calculate RX-path IQ imbalance and setting RX path IQ compensation table */
 
 	result = _rx_iq_calibration_loop_winbond(phw_data, 12589, frequency);
 
@@ -1454,7 +1454,7 @@ void phy_calibration_winbond(struct hw_data *phw_data, u32 frequency)
 
 	_rxadc_dc_offset_cancellation_winbond(phw_data, frequency);
 	/* _txidac_dc_offset_cancellation_winbond(phw_data); */
-	/* _txqdac_dc_offset_cacellation_winbond(phw_data); */
+	/* _txqdac_dc_offset_cancellation_winbond(phw_data); */
 
 	_tx_iq_calibration_winbond(phw_data);
 	_rx_iq_calibration_winbond(phw_data, frequency);
diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index 1b38d6d..5ecf9a1 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -693,7 +693,7 @@ u32 w89rf242_rf_data[] = {
 	(0x0E << 24) | 0x5557DC, /* 1555F ; IBSC  (0x0E) -- IRLNA & IRLNB (PTAT & Const current)=01/01; FA5976B_1.3F */
 	(0x10 << 24) | 0x000C20, /* 00030 ; TMODA (0x10) -- LNA_gain_step=0011 ; LNA=15/16dB */
 	(0x11 << 24) | 0x0C0022, /* 03000 ; TMODB (0x11) -- Turn ON RX-Q path Test Switch; To improve IQ path group delay (FA5976A_1.3C) */
-	(0x12 << 24) | 0x000024  /* TMODC (0x12) -- Turn OFF Tempearure sensor */
+	(0x12 << 24) | 0x000024  /* TMODC (0x12) -- Turn OFF Temperature sensor */
 };
 
 u32 w89rf242_channel_data_24[][2] = {
diff --git a/drivers/staging/winbond/sme_api.h b/drivers/staging/winbond/sme_api.h
index 8f4596c..712331b 100644
--- a/drivers/staging/winbond/sme_api.h
+++ b/drivers/staging/winbond/sme_api.h
@@ -107,7 +107,7 @@ s8 sme_set_bssid_list_scan(void *pcore_data, void *pscan_para);
 s8 sme_set_reload_defaults(void *pcore_data, u8 reload_type);
 
 
-/*------------------------- none-standard ----------------------------------*/
+/*------------------------- non-standard ----------------------------------*/
 s8 sme_get_connect_status(void *pcore_data, u8 *pstatus);
 /*--------------------------------------------------------------------------*/
 
diff --git a/drivers/staging/winbond/wb35reg.c b/drivers/staging/winbond/wb35reg.c
index da595f1..1bff7d1 100644
--- a/drivers/staging/winbond/wb35reg.c
+++ b/drivers/staging/winbond/wb35reg.c
@@ -217,7 +217,7 @@ unsigned char Wb35Reg_Write(struct hw_data *pHwData, u16 RegisterNo, u32 Registe
  * This command will be executed with a user defined value. When it completes,
  * this value is useful. For example, hal_set_current_channel will use it.
  * true  : read command process successfully
- * false : register not support
+ * false : register not supported
  */
 unsigned char Wb35Reg_WriteWithCallbackValue(struct hw_data *pHwData,
 						u16 RegisterNo,
@@ -631,7 +631,7 @@ unsigned char Wb35Reg_initial(struct hw_data *pHwData)
  *  CardComputeCrc --
  *
  *  Description:
- *    Runs the AUTODIN II CRC algorithm on buffer Buffer of length, Length.
+ *    Runs the AUTODIN II CRC algorithm on the buffers Buffer length.
  *
  *  Arguments:
  *    Buffer - the input buffer
diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index 5df39d4..0f870da 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
@@ -149,14 +149,14 @@ void Wb35Tx_stop(struct hw_data * pHwData)
 {
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 
-	// Trying to canceling the Trp of EP2
+	// Try to cancel the Trp of EP2
 	if (pWb35Tx->EP2vm_state == VM_RUNNING)
-		usb_unlink_urb( pWb35Tx->Tx2Urb ); // Only use unlink, let Wb35Tx_destrot to free them
+		usb_unlink_urb( pWb35Tx->Tx2Urb ); // Only use unlink, let Wb35Tx_destroy to free them
 	pr_debug("EP2 Tx stop\n");
 
-	// Trying to canceling the Irp of EP4
+	// Try to cancel the Irp of EP4
 	if (pWb35Tx->EP4vm_state == VM_RUNNING)
-		usb_unlink_urb( pWb35Tx->Tx4Urb ); // Only use unlink, let Wb35Tx_destrot to free them
+		usb_unlink_urb( pWb35Tx->Tx4Urb ); // Only use unlink, let Wb35Tx_destroy to free them
 	pr_debug("EP4 Tx stop\n");
 }
 
diff --git a/drivers/staging/winbond/wb35tx_s.h b/drivers/staging/winbond/wb35tx_s.h
index f70f433..9186526 100644
--- a/drivers/staging/winbond/wb35tx_s.h
+++ b/drivers/staging/winbond/wb35tx_s.h
@@ -41,7 +41,7 @@ struct wb35_tx {
 	int		EP4VM_status;
 
 	u32	TxFillCount; // 20060928
-	u32	TxTimer; // 20060928 Add if sending packet not great than 13
+	u32	TxTimer; // 20060928 Add if sending packet is greater than 13
 };
 
 #endif
-- 
1.7.9.5

