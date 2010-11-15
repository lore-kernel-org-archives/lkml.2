Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab0KODGB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:06:01 -0500
Received: from mail.perches.com ([173.55.12.10]:1211 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690Ab0KODFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:54 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=2029/44=5D=20drivers/staging=3A=20Remove=20unnecessary=20semicolons?=
Date: Sun, 14 Nov 2010 19:04:48 -0800
Message-Id: <3246dc176a2c553078e73332f02d802dd8ef7942.1289789605.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |    2 +-
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |    2 +-
 drivers/staging/bcm/InterfaceInit.c                |    2 +-
 drivers/staging/bcm/InterfaceIsr.c                 |    2 +-
 drivers/staging/bcm/Misc.c                         |    4 ++--
 .../comedi/drivers/addi-data/APCI1710_Tor.c        |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1516.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |    2 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |    2 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |    2 +-
 drivers/staging/comedi/drivers/comedi_bond.c       |    2 +-
 drivers/staging/crystalhd/crystalhd_hw.c           |    2 +-
 drivers/staging/go7007/go7007-driver.c             |    2 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c         |    2 +-
 .../staging/intel_sst/intel_sst_drv_interface.c    |    4 ++--
 drivers/staging/keucr/smilmain.c                   |    4 ++--
 drivers/staging/keucr/smilsub.c                    |    4 ++--
 drivers/staging/msm/lcdc_toshiba_wvga_pt.c         |    2 +-
 drivers/staging/rt2860/common/cmm_data_pci.c       |    4 ++--
 drivers/staging/rt2860/rt_linux.c                  |    2 +-
 drivers/staging/rt2860/rtmp.h                      |    2 +-
 drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c  |    2 +-
 drivers/staging/rtl8192e/r819xE_phy.c              |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |    2 +-
 drivers/staging/rtl8192u/r8192U_core.c             |    2 +-
 drivers/staging/rtl8192u/r819xU_phy.c              |    2 +-
 drivers/staging/rtl8712/rtl8712_efuse.c            |    2 +-
 drivers/staging/rtl8712/rtl8712_xmit.c             |    2 +-
 drivers/staging/rtl8712/rtl871x_xmit.c             |    2 +-
 drivers/staging/tidspbridge/core/tiomap3430.c      |    4 ++--
 drivers/staging/tidspbridge/rmgr/nldr.c            |    2 +-
 drivers/staging/vt6655/card.c                      |    2 +-
 drivers/staging/vt6655/iwctl.c                     |    2 +-
 drivers/staging/vt6655/wpa2.c                      |    4 ++--
 drivers/staging/vt6656/baseband.c                  |    2 +-
 drivers/staging/vt6656/iwctl.c                     |    2 +-
 drivers/staging/vt6656/power.c                     |    2 +-
 drivers/staging/vt6656/wpa2.c                      |    4 ++--
 39 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
index c307a55..3963038 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
@@ -876,7 +876,7 @@ HIFAckInterrupt(HIF_DEVICE *device)
 void
 HIFUnMaskInterrupt(HIF_DEVICE *device)
 {
-    int ret;;
+    int ret;
 
     AR_DEBUG_ASSERT(device != NULL);
     AR_DEBUG_ASSERT(device->func != NULL);
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index a659f70..126a36a 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -4439,7 +4439,7 @@ skip_key:
         for (i = assoc_req_ie_pos; i < assoc_req_ie_pos + assocReqLen - 4; i++) {
             AR_DEBUG_PRINTF(ATH_DEBUG_WLAN_CONNECT,("%2.2x ", assocInfo[i]));
             sprintf(pos, "%2.2x", assocInfo[i]);
-            pos += 2;;
+            pos += 2;
         }
         AR_DEBUG_PRINTF(ATH_DEBUG_WLAN_CONNECT,("\n"));
 
diff --git a/drivers/staging/bcm/InterfaceInit.c b/drivers/staging/bcm/InterfaceInit.c
index 824f9a4..a368011 100644
--- a/drivers/staging/bcm/InterfaceInit.c
+++ b/drivers/staging/bcm/InterfaceInit.c
@@ -265,7 +265,7 @@ usbbcm_device_probe(struct usb_interface *intf, const struct usb_device_id *id)
 		uint32_t uiNackZeroLengthInt=4;
 		if(wrmalt(psAdapter, DISABLE_USB_ZERO_LEN_INT, &uiNackZeroLengthInt, sizeof(uiNackZeroLengthInt)))
 		{
-			return -EIO;;
+			return -EIO;
 		}
 	}
 
diff --git a/drivers/staging/bcm/InterfaceIsr.c b/drivers/staging/bcm/InterfaceIsr.c
index f928fe4..604d07f 100644
--- a/drivers/staging/bcm/InterfaceIsr.c
+++ b/drivers/staging/bcm/InterfaceIsr.c
@@ -87,7 +87,7 @@ static void read_int_callback(struct urb *urb/*, struct pt_regs *regs*/)
 				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Interrupt IN endPoint  has got halted/stalled...need to clear this");
 				Adapter->bEndPointHalted = TRUE ;
 				wake_up(&Adapter->tx_packet_wait_queue);
-				urb->status = STATUS_SUCCESS ;;
+				urb->status = STATUS_SUCCESS ;
 				return;
 		}
 	    /* software-driven interface shutdown */
diff --git a/drivers/staging/bcm/Misc.c b/drivers/staging/bcm/Misc.c
index 22550f7..cd14fec 100644
--- a/drivers/staging/bcm/Misc.c
+++ b/drivers/staging/bcm/Misc.c
@@ -764,7 +764,7 @@ void SendIdleModeResponse(PMINI_ADAPTER Adapter)
 
 			/* Wake the LED Thread with IDLEMODE_ENTER State */
 			Adapter->DriverState = LOWPOWER_MODE_ENTER;
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL,"LED Thread is Running..Hence Setting LED Event as IDLEMODE_ENTER jiffies:%ld",jiffies);;
+			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL,"LED Thread is Running..Hence Setting LED Event as IDLEMODE_ENTER jiffies:%ld",jiffies);
 			wake_up(&Adapter->LEDInfo.notify_led_event);
 
 			/* Wait for 1 SEC for LED to OFF */
@@ -1410,7 +1410,7 @@ int bcm_parse_target_params(PMINI_ADAPTER Adapter)
 
 void beceem_parse_target_struct(PMINI_ADAPTER Adapter)
 {
-	UINT uiHostDrvrCfg6 =0, uiEEPROMFlag = 0;;
+	UINT uiHostDrvrCfg6 =0, uiEEPROMFlag = 0;
 
 	if(ntohl(Adapter->pstargetparams->m_u32PhyParameter2) & AUTO_SYNC_DISABLE)
 	{
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
index 7361d50..0e6affd 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
@@ -1008,7 +1008,7 @@ int i_APCI1710_InsnWriteEnableDisableTorCounter(struct comedi_device *dev,
 	b_ExternGate = (unsigned char) data[3];
 	b_CycleMode = (unsigned char) data[4];
 	b_InterruptEnable = (unsigned char) data[5];
-	i_ReturnValue = insn->n;;
+	i_ReturnValue = insn->n;
 	devpriv->tsk_Current = current;	/*  Save the current process task structure */
 	/**************************/
 	/* Test the module number */
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index 2a8a6c7..62f421a 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -2850,7 +2850,7 @@ static int i_APCI1500_Reset(struct comedi_device *dev)
 	i_Logic = 0;
 	i_CounterLogic = 0;
 	i_InterruptMask = 0;
-	i_InputChannel = 0;;
+	i_InputChannel = 0;
 	i_TimerCounter1Enabled = 0;
 	i_TimerCounter2Enabled = 0;
 	i_WatchdogCounter3Enabled = 0;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
index 12fcc35..8a584a0 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
@@ -335,7 +335,7 @@ int i_APCI1516_WriteDigitalOutput(struct comedi_device *dev, struct comedi_subde
 			return -EINVAL;
 		}		/* if else data[3]==1) */
 	}			/* if else data[3]==0) */
-	return (insn->n);;
+	return (insn->n);
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
index 356a189..acaceb0 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
@@ -339,7 +339,7 @@ int i_APCI3501_ConfigAnalogOutput(struct comedi_device *dev, struct comedi_subde
 int i_APCI3501_WriteAnalogOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
-	unsigned int ul_Command1 = 0, ul_Channel_no, ul_Polarity, ul_DAC_Ready = 0;;
+	unsigned int ul_Command1 = 0, ul_Channel_no, ul_Polarity, ul_DAC_Ready = 0;
 
 	ul_Channel_no = CR_CHAN(insn->chanspec);
 
diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 5d06457..7edeb11 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -971,7 +971,7 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (thisboard->ao_chans > 0) {
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_WRITABLE | SDF_GROUND;
-		s->n_chan = thisboard->ao_chans;;
+		s->n_chan = thisboard->ao_chans;
 		s->maxdata = (1 << thisboard->ao_bits) - 1;
 		s->range_table = &pci230_ao_range;
 		s->insn_write = &pci230_ao_winsn;
diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 0345b4c..bb93685 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -169,7 +169,7 @@ static int das16cs_attach(struct comedi_device *dev,
 	if (!link)
 		return -EIO;
 
-	dev->iobase = link->resource[0]->start;;
+	dev->iobase = link->resource[0]->start;
 	printk("I/O base=0x%04lx ", dev->iobase);
 
 	printk("fingerprint:\n");
diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index cfcbd9b..d8aefb2 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -370,7 +370,7 @@ static int doDevConfig(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct comedi_device *devs_opened[COMEDI_NUM_BOARD_MINORS];
 
 	memset(devs_opened, 0, sizeof(devs_opened));
-	devpriv->name[0] = 0;;
+	devpriv->name[0] = 0;
 	/* Loop through all comedi devices specified on the command-line,
 	   building our device list */
 	for (i = 0; i < COMEDI_NDEVCONFOPTS && (!i || it->options[i]); ++i) {
diff --git a/drivers/staging/crystalhd/crystalhd_hw.c b/drivers/staging/crystalhd/crystalhd_hw.c
index f631857..153ddbf 100644
--- a/drivers/staging/crystalhd/crystalhd_hw.c
+++ b/drivers/staging/crystalhd/crystalhd_hw.c
@@ -1711,7 +1711,7 @@ enum BC_STATUS crystalhd_download_fw(struct crystalhd_adp *adp, void *buffer, ui
 	}
 
 	BCMLOG(BCMLOG_INFO, "Firmware Downloaded Successfully\n");
-	return BC_STS_SUCCESS;;
+	return BC_STS_SUCCESS;
 }
 
 enum BC_STATUS crystalhd_do_fw_cmd(struct crystalhd_hw *hw,
diff --git a/drivers/staging/go7007/go7007-driver.c b/drivers/staging/go7007/go7007-driver.c
index b3f42f3..8426a02 100644
--- a/drivers/staging/go7007/go7007-driver.c
+++ b/drivers/staging/go7007/go7007-driver.c
@@ -624,7 +624,7 @@ struct go7007 *go7007_alloc(struct go7007_board_info *board, struct device *dev)
 	go->dvd_mode = 0;
 	go->interlace_coding = 0;
 	for (i = 0; i < 4; ++i)
-		go->modet[i].enable = 0;;
+		go->modet[i].enable = 0;
 	for (i = 0; i < 1624; ++i)
 		go->modet_map[i] = 0;
 	go->audio_deliver = NULL;
diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
index 330d5d6..1fd088a 100644
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -517,7 +517,7 @@ int lis3l02dq_configure_ring(struct iio_dev *indio_dev)
 
 	ret = iio_alloc_pollfunc(indio_dev, NULL, &lis3l02dq_poll_func_th);
 	if (ret)
-		goto error_iio_sw_rb_free;;
+		goto error_iio_sw_rb_free;
 	indio_dev->modes |= INDIO_RING_TRIGGERED;
 	return 0;
 
diff --git a/drivers/staging/intel_sst/intel_sst_drv_interface.c b/drivers/staging/intel_sst/intel_sst_drv_interface.c
index 669e298..6443fbd 100644
--- a/drivers/staging/intel_sst/intel_sst_drv_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_drv_interface.c
@@ -171,9 +171,9 @@ static int sst_get_sfreq(struct snd_sst_params *str_param)
 	case SST_CODEC_TYPE_MP3:
 		return str_param->sparams.uc.mp3_params.sfreq;
 	case SST_CODEC_TYPE_AAC:
-		return str_param->sparams.uc.aac_params.sfreq;;
+		return str_param->sparams.uc.aac_params.sfreq;
 	case SST_CODEC_TYPE_WMA9:
-		return str_param->sparams.uc.wma_params.sfreq;;
+		return str_param->sparams.uc.wma_params.sfreq;
 	default:
 		return 0;
 	}
diff --git a/drivers/staging/keucr/smilmain.c b/drivers/staging/keucr/smilmain.c
index bdfbf76..2cbe9f8 100644
--- a/drivers/staging/keucr/smilmain.c
+++ b/drivers/staging/keucr/smilmain.c
@@ -153,9 +153,9 @@ int Media_D_ReadSector(struct us_data *us, DWORD start,WORD count,BYTE *buf)
 	WORD len, bn;
 
 	//if (Check_D_MediaPower())        ; ¦b 6250 don't care
-	//    return(ErrCode);             ;
+	//    return(ErrCode);
 	//if (Check_D_MediaFmt(fdoExt))    ;
-	//    return(ErrCode);             ;
+	//    return(ErrCode);
 	if (Conv_D_MediaAddr(us, start))
 		return(ErrCode);
 
diff --git a/drivers/staging/keucr/smilsub.c b/drivers/staging/keucr/smilsub.c
index 1b52535..ce10cf2 100644
--- a/drivers/staging/keucr/smilsub.c
+++ b/drivers/staging/keucr/smilsub.c
@@ -763,8 +763,8 @@ int Ssfdc_D_WriteSectForCopy(struct us_data *us, BYTE *buf, BYTE *redundant)
 	bcb->CDB[7]			= (BYTE)addr;
 	bcb->CDB[6]			= (BYTE)(addr/0x0100);
 	bcb->CDB[5]			= Media.Zone/2;
-	bcb->CDB[8]			= *(redundant+REDT_ADDR1H);;
-	bcb->CDB[9]			= *(redundant+REDT_ADDR1L);;
+	bcb->CDB[8]			= *(redundant+REDT_ADDR1H);
+	bcb->CDB[9]			= *(redundant+REDT_ADDR1L);
 
 	result = ENE_SendScsiCmd(us, FDIR_WRITE, buf, 0);
 	if (result != USB_STOR_XFER_GOOD)
diff --git a/drivers/staging/msm/lcdc_toshiba_wvga_pt.c b/drivers/staging/msm/lcdc_toshiba_wvga_pt.c
index 864d7c1..edba78a 100644
--- a/drivers/staging/msm/lcdc_toshiba_wvga_pt.c
+++ b/drivers/staging/msm/lcdc_toshiba_wvga_pt.c
@@ -77,7 +77,7 @@ static void toshiba_spi_write(char cmd, uint32 data, int num)
 
 	/* followed by parameter bytes */
 	if (num) {
-		bp = (char *)&data;;
+		bp = (char *)&data;
 		bp += (num - 1);
 		while (num) {
 			toshiba_spi_write_byte(1, *bp);
diff --git a/drivers/staging/rt2860/common/cmm_data_pci.c b/drivers/staging/rt2860/common/cmm_data_pci.c
index 43d73a0..7af59ff 100644
--- a/drivers/staging/rt2860/common/cmm_data_pci.c
+++ b/drivers/staging/rt2860/common/cmm_data_pci.c
@@ -137,7 +137,7 @@ u16 RtmpPCI_WriteSingleTxResource(struct rt_rtmp_adapter *pAd,
 
 	pTxD->SDPtr0 = BufBasePaLow;
 	pTxD->SDLen0 = TXINFO_SIZE + TXWI_SIZE + hwHeaderLen;	/* include padding */
-	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);;
+	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);
 	pTxD->SDLen1 = pTxBlk->SrcBufLen;
 	pTxD->LastSec0 = 0;
 	pTxD->LastSec1 = (bIsLast) ? 1 : 0;
@@ -215,7 +215,7 @@ u16 RtmpPCI_WriteMultiTxResource(struct rt_rtmp_adapter *pAd,
 
 	pTxD->SDPtr0 = BufBasePaLow;
 	pTxD->SDLen0 = firstDMALen;	/* include padding */
-	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);;
+	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);
 	pTxD->SDLen1 = pTxBlk->SrcBufLen;
 	pTxD->LastSec0 = 0;
 	pTxD->LastSec1 = (bIsLast) ? 1 : 0;
diff --git a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_linux.c
index abfeea1..7dad6ee 100644
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -854,7 +854,7 @@ void send_monitor_packets(struct rt_rtmp_adapter *pAd, struct rt_rx_blk *pRxBlk)
 									 RSSI1,
 									 RSSI_1),
 				    ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI2,
-						  RSSI_2));;
+						  RSSI_2));
 
 	ph->signal.did = DIDmsg_lnxind_wlansniffrm_signal;
 	ph->signal.status = 0;
diff --git a/drivers/staging/rt2860/rtmp.h b/drivers/staging/rt2860/rtmp.h
index ca54e53..26cc823 100644
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -2978,7 +2978,7 @@ void LinkDown(struct rt_rtmp_adapter *pAd, IN BOOLEAN IsReqFromAP);
 
 void IterateOnBssTab(struct rt_rtmp_adapter *pAd);
 
-void IterateOnBssTab2(struct rt_rtmp_adapter *pAd);;
+void IterateOnBssTab2(struct rt_rtmp_adapter *pAd);
 
 void JoinParmFill(struct rt_rtmp_adapter *pAd,
 		  struct rt_mlme_join_req *JoinReq, unsigned long BssIdx);
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
index dd8a221..b26b5a8 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
@@ -822,7 +822,7 @@ int ieee80211_rtl_xmit(struct sk_buff *skb, struct net_device *dev)
 		{
 			txb->queue_index = UP2AC(skb->priority);
 		} else {
-			txb->queue_index = WME_AC_BK;;
+			txb->queue_index = WME_AC_BK;
 		}
 
 
diff --git a/drivers/staging/rtl8192e/r819xE_phy.c b/drivers/staging/rtl8192e/r819xE_phy.c
index d83bcbc..50cd0e5 100644
--- a/drivers/staging/rtl8192e/r819xE_phy.c
+++ b/drivers/staging/rtl8192e/r819xE_phy.c
@@ -2596,7 +2596,7 @@ u8 rtl8192_phy_ConfigRFWithHeaderFile(struct net_device* dev, RF90_RADIO_PATH_E
 			break;
 	}
 
-	return ret;;
+	return ret;
 
 }
 /******************************************************************************
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
index 81aa2ed..ec7845e 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
@@ -754,7 +754,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 		{
 			txb->queue_index = UP2AC(skb->priority);
 		} else {
-			txb->queue_index = WME_AC_BK;;
+			txb->queue_index = WME_AC_BK;
 		}
 
 
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 494f180..1139a27 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -5085,7 +5085,7 @@ static void rtl8192_query_rxphystatus(
 			//Get Rx snr value in DB
 			tmp_rxsnr =	pofdm_buf->rxsnr_X[i];
 			rx_snrX = (char)(tmp_rxsnr);
-			//rx_snrX >>= 1;;
+			//rx_snrX >>= 1;
 			rx_snrX /= 2;
 			priv->stats.rxSNRdB[i] = (long)rx_snrX;
 
diff --git a/drivers/staging/rtl8192u/r819xU_phy.c b/drivers/staging/rtl8192u/r819xU_phy.c
index a3adaed..8e10992 100644
--- a/drivers/staging/rtl8192u/r819xU_phy.c
+++ b/drivers/staging/rtl8192u/r819xU_phy.c
@@ -1011,7 +1011,7 @@ u8 rtl8192_phy_ConfigRFWithHeaderFile(struct net_device* dev, RF90_RADIO_PATH_E
 			break;
 	}
 
-	return ret;;
+	return ret;
 
 }
 /******************************************************************************
diff --git a/drivers/staging/rtl8712/rtl8712_efuse.c b/drivers/staging/rtl8712/rtl8712_efuse.c
index 9730ae1..1dc12b7 100644
--- a/drivers/staging/rtl8712/rtl8712_efuse.c
+++ b/drivers/staging/rtl8712/rtl8712_efuse.c
@@ -428,7 +428,7 @@ u8 r8712_efuse_access(struct _adapter *padapter, u8 bRead, u16 start_addr,
 		      u16 cnts, u8 *data)
 {
 	int i;
-	u8 res = true;;
+	u8 res = true;
 
 	if (start_addr > EFUSE_MAX_SIZE)
 		return false;
diff --git a/drivers/staging/rtl8712/rtl8712_xmit.c b/drivers/staging/rtl8712/rtl8712_xmit.c
index 8edc518..88a1504 100644
--- a/drivers/staging/rtl8712/rtl8712_xmit.c
+++ b/drivers/staging/rtl8712/rtl8712_xmit.c
@@ -148,7 +148,7 @@ static u32 get_ff_hwaddr(struct xmit_frame *pxmitframe)
 		case 0x11:
 		case 0x12:
 		case 0x13:
-			addr = RTL8712_DMA_H2CCMD;;
+			addr = RTL8712_DMA_H2CCMD;
 			break;
 		default:
 			addr = RTL8712_DMA_BEQ;/*RTL8712_EP_LO;*/
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.c b/drivers/staging/rtl8712/rtl871x_xmit.c
index b8195e3..75f1a6b 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.c
+++ b/drivers/staging/rtl8712/rtl871x_xmit.c
@@ -372,7 +372,7 @@ static sint xmitframe_addmic(struct _adapter *padapter,
 					   0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
 					   0x0, 0x0};
 			datalen = pattrib->pktlen - pattrib->hdrlen;
-			pframe = pxmitframe->buf_addr + TXDESC_OFFSET;;
+			pframe = pxmitframe->buf_addr + TXDESC_OFFSET;
 			if (bmcst) {
 				if (!memcmp(psecuritypriv->XGrptxmickey
 				   [psecuritypriv->XGrpKeyid].skey,
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 1be081f..a3b0a18 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -596,7 +596,7 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 		dev_dbg(bridge, "DSP c_int00 Address =  0x%x\n", dsp_addr);
 		if (dsp_debug)
 			while (__raw_readw(dw_sync_addr))
-				;;
+				;
 
 		/* Wait for DSP to clear word in shared memory */
 		/* Read the Location */
@@ -1671,7 +1671,7 @@ static int pte_set(struct pg_table_attrs *pt, u32 pa, u32 va,
 			/* Find a free L2 PT. */
 			for (i = 0; (i < pt->l2_num_pages) &&
 			     (pt->pg_info[i].num_entries != 0); i++)
-				;;
+				;
 			if (i < pt->l2_num_pages) {
 				l2_page_num = i;
 				l2_base_pa = pt->l2_base_pa + (l2_page_num *
diff --git a/drivers/staging/tidspbridge/rmgr/nldr.c b/drivers/staging/tidspbridge/rmgr/nldr.c
index a6ae007..28354bb 100644
--- a/drivers/staging/tidspbridge/rmgr/nldr.c
+++ b/drivers/staging/tidspbridge/rmgr/nldr.c
@@ -943,7 +943,7 @@ static int add_ovly_info(void *handle, struct dbll_sect_info *sect_info,
 
 	/* Determine which phase this section belongs to */
 	for (pch = sect_name + 1; *pch && *pch != seps; pch++)
-		;;
+		;
 
 	if (*pch) {
 		pch++;		/* Skip over the ':' */
diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 32d095c..951a3a8 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -2058,7 +2058,7 @@ bool CARDbSoftwareReset (void *pDeviceHandler)
 QWORD CARDqGetTSFOffset (unsigned char byRxRate, QWORD qwTSF1, QWORD qwTSF2)
 {
     QWORD   qwTSFOffset;
-    unsigned short wRxBcnTSFOffst= 0;;
+    unsigned short wRxBcnTSFOffst= 0;
 
     HIDWORD(qwTSFOffset) = 0;
     LODWORD(qwTSFOffset) = 0;
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 92e3399..5e425d1 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -2073,7 +2073,7 @@ int iwctl_giwencodeext(struct net_device *dev,
              struct iw_point *wrq,
              char *extra)
 {
-		return -EOPNOTSUPP;;
+		return -EOPNOTSUPP;
 }
 
 int iwctl_siwmlme(struct net_device *dev,
diff --git a/drivers/staging/vt6655/wpa2.c b/drivers/staging/vt6655/wpa2.c
index 805164b..744799c 100644
--- a/drivers/staging/vt6655/wpa2.c
+++ b/drivers/staging/vt6655/wpa2.c
@@ -216,7 +216,7 @@ WPA2vParseRSN (
         m = *((unsigned short *) &(pRSN->abyRSN[4]));
 
         if (pRSN->len >= 10+m*4) { // ver(2) + GK(4) + PK count(2) + PKS(4*m) + AKMSS count(2)
-            pBSSNode->wAKMSSAuthCount = *((unsigned short *) &(pRSN->abyRSN[6+4*m]));;
+            pBSSNode->wAKMSSAuthCount = *((unsigned short *) &(pRSN->abyRSN[6+4*m]));
             j = 0;
             pbyOUI = &(pRSN->abyRSN[8+4*m]);
             for (i = 0; (i < pBSSNode->wAKMSSAuthCount) && (j < sizeof(pBSSNode->abyAKMSSAuthType)/sizeof(unsigned char)); i++) {
@@ -235,7 +235,7 @@ WPA2vParseRSN (
             pBSSNode->wAKMSSAuthCount = (unsigned short)j;
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wAKMSSAuthCount: %d\n", pBSSNode->wAKMSSAuthCount);
 
-            n = *((unsigned short *) &(pRSN->abyRSN[6+4*m]));;
+            n = *((unsigned short *) &(pRSN->abyRSN[6+4*m]));
             if (pRSN->len >= 12+4*m+4*n) { // ver(2)+GK(4)+PKCnt(2)+PKS(4*m)+AKMSSCnt(2)+AKMSS(4*n)+Cap(2)
                 pBSSNode->sRSNCapObj.bRSNCapExist = true;
                 pBSSNode->sRSNCapObj.wRSNCap = *((unsigned short *) &(pRSN->abyRSN[8+4*m+4*n]));
diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index e5add20..0d11147 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -963,7 +963,7 @@ BBvSetAntennaMode (PSDevice pDevice, BYTE byAntennaMode)
             break;
         case ANT_RXB:
             pDevice->byBBRxConf &= 0xFE;
-            pDevice->byBBRxConf |= 0x02;;
+            pDevice->byBBRxConf |= 0x02;
             break;
     }
 
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 0004be8..2121205 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1883,7 +1883,7 @@ int iwctl_giwencodeext(struct net_device *dev,
              struct iw_point *wrq,
              char *extra)
 {
-		return -EOPNOTSUPP;;
+		return -EOPNOTSUPP;
 }
 
 int iwctl_siwmlme(struct net_device *dev,
diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index 0c12fd3..e8c1b35 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -192,7 +192,7 @@ BOOL PSbConsiderPowerDown(void *hDeviceContext,
     // check if already in Doze mode
     ControlvReadByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PSCTL, &byData);
     if ( (byData & PSCTL_PS) != 0 )
-        return TRUE;;
+        return TRUE;
 
     if (pMgmt->eCurrMode != WMAC_MODE_IBSS_STA) {
         // check if in TIM wake period
diff --git a/drivers/staging/vt6656/wpa2.c b/drivers/staging/vt6656/wpa2.c
index 6d13190..d4f3f75 100644
--- a/drivers/staging/vt6656/wpa2.c
+++ b/drivers/staging/vt6656/wpa2.c
@@ -215,7 +215,7 @@ WPA2vParseRSN (
         m = *((PWORD) &(pRSN->abyRSN[4]));
 
         if (pRSN->len >= 10+m*4) { // ver(2) + GK(4) + PK count(2) + PKS(4*m) + AKMSS count(2)
-            pBSSNode->wAKMSSAuthCount = *((PWORD) &(pRSN->abyRSN[6+4*m]));;
+            pBSSNode->wAKMSSAuthCount = *((PWORD) &(pRSN->abyRSN[6+4*m]));
             j = 0;
             pbyOUI = &(pRSN->abyRSN[8+4*m]);
             for (i = 0; (i < pBSSNode->wAKMSSAuthCount) && (j < sizeof(pBSSNode->abyAKMSSAuthType)/sizeof(BYTE)); i++) {
@@ -234,7 +234,7 @@ WPA2vParseRSN (
             pBSSNode->wAKMSSAuthCount = (WORD)j;
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wAKMSSAuthCount: %d\n", pBSSNode->wAKMSSAuthCount);
 
-            n = *((PWORD) &(pRSN->abyRSN[6+4*m]));;
+            n = *((PWORD) &(pRSN->abyRSN[6+4*m]));
             if (pRSN->len >= 12+4*m+4*n) { // ver(2)+GK(4)+PKCnt(2)+PKS(4*m)+AKMSSCnt(2)+AKMSS(4*n)+Cap(2)
                 pBSSNode->sRSNCapObj.bRSNCapExist = TRUE;
                 pBSSNode->sRSNCapObj.wRSNCap = *((PWORD) &(pRSN->abyRSN[8+4*m+4*n]));
-- 
1.7.3.1.g432b3.dirty

