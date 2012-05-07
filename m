Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab2EGOig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:38:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39878 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644Ab2EGOid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:38:33 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: florian.c.schilhabel@googlemail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, evel@driverdev.osuosl.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH NEXT]"staging" "rtl8712" Fix typos.
Date: Mon,  7 May 2012 07:38:22 -0700
Message-Id: <1336401502-15586-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch fixes some typos while going through rtl8712. 

 drivers/staging/rtl8712/drv_types.h             |    2 +-
 drivers/staging/rtl8712/ieee80211.h             |    2 +-
 drivers/staging/rtl8712/if_ether.h              |    2 +-
 drivers/staging/rtl8712/os_intfs.c              |    4 ++--
 drivers/staging/rtl8712/rtl8712_cmd.c           |    6 +++---
 drivers/staging/rtl8712/rtl8712_cmd.h           |    2 +-
 drivers/staging/rtl8712/rtl8712_efuse.c         |    2 +-
 drivers/staging/rtl8712/rtl8712_gp_bitdef.h     |    2 +-
 drivers/staging/rtl8712/rtl8712_hal.h           |    4 ++--
 drivers/staging/rtl8712/rtl8712_led.c           |    6 +++---
 drivers/staging/rtl8712/rtl8712_recv.c          |    4 ++--
 drivers/staging/rtl8712/rtl871x_cmd.h           |    2 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c   |   14 +++++++-------
 drivers/staging/rtl8712/rtl871x_ioctl_set.c     |    2 +-
 drivers/staging/rtl8712/rtl871x_mlme.c          |    8 ++++----
 drivers/staging/rtl8712/rtl871x_mlme.h          |    6 +++---
 drivers/staging/rtl8712/rtl871x_mp_phy_regdef.h |    4 ++--
 drivers/staging/rtl8712/rtl871x_xmit.c          |    2 +-
 drivers/staging/rtl8712/rtl871x_xmit.h          |    2 +-
 drivers/staging/rtl8712/usb_halinit.c           |    4 ++--
 drivers/staging/rtl8712/usb_intf.c              |    2 +-
 21 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/rtl8712/drv_types.h b/drivers/staging/rtl8712/drv_types.h
index e83665d..62b5566 100644
--- a/drivers/staging/rtl8712/drv_types.h
+++ b/drivers/staging/rtl8712/drv_types.h
@@ -146,7 +146,7 @@ struct dvobj_priv {
 /**
  * struct _adapter - the main adapter structure for this device.
  *
- * bup: True indicates that the interface is Up.
+ * bup: True indicates that the interface is up.
  */
 struct _adapter {
 	struct	dvobj_priv dvobjpriv;
diff --git a/drivers/staging/rtl8712/ieee80211.h b/drivers/staging/rtl8712/ieee80211.h
index 3c0092b..21515c3 100644
--- a/drivers/staging/rtl8712/ieee80211.h
+++ b/drivers/staging/rtl8712/ieee80211.h
@@ -705,7 +705,7 @@ enum ieee80211_state {
 	IEEE80211_ASSOCIATING_RETRY,
 	/* the association procedure is sending AUTH request*/
 	IEEE80211_ASSOCIATING_AUTHENTICATING,
-	/* the association procedure has successfully authentcated
+	/* the association procedure has successfully authenticated
 	 * and is sending association request
 	 */
 	IEEE80211_ASSOCIATING_AUTHENTICATED,
diff --git a/drivers/staging/rtl8712/if_ether.h b/drivers/staging/rtl8712/if_ether.h
index 2bbe527..9916b6a 100644
--- a/drivers/staging/rtl8712/if_ether.h
+++ b/drivers/staging/rtl8712/if_ether.h
@@ -25,7 +25,7 @@
  ******************************************************************************/
 /*
  * INET		An implementation of the TCP/IP protocol suite for the LINUX
- *		operating system.  INET is implemented using the  BSD Socket
+ *		operating system.  INET is implemented using the BSD Socket
  *		interface as the means of communication with the user level.
  *
  *		Global definitions for the Ethernet IEEE 802.3 interface.
diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/os_intfs.c
index 7bbd53a..448f00d 100644
--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -52,7 +52,7 @@ static int lbkmode = RTL8712_AIR_TRX;
 static int hci = RTL8712_USB;
 static int ampdu_enable = 1;/*for enable tx_ampdu*/
 
-/* The video_mode variable is for vedio mode.*/
+/* The video_mode variable is for video mode.*/
 /* It may be specify when inserting module with video_mode=1 parameter.*/
 static int video_mode = 1;   /* enable video mode*/
 
@@ -248,7 +248,7 @@ static u32 start_drv_threads(struct _adapter *padapter)
 
 void r8712_stop_drv_threads(struct _adapter *padapter)
 {
-	/*Below is to termindate r8712_cmd_thread & event_thread...*/
+	/*Below is to terminate r8712_cmd_thread & event_thread...*/
 	up(&padapter->cmdpriv.cmd_queue_sema);
 	if (padapter->cmdThread)
 		_down_sema(&padapter->cmdpriv.terminate_cmdthread_sema);
diff --git a/drivers/staging/rtl8712/rtl8712_cmd.c b/drivers/staging/rtl8712/rtl8712_cmd.c
index 9f6ebc4..6c4a94c 100644
--- a/drivers/staging/rtl8712/rtl8712_cmd.c
+++ b/drivers/staging/rtl8712/rtl8712_cmd.c
@@ -69,7 +69,7 @@ static void check_hw_pbc(struct _adapter *padapter)
 		 * After trigger PBC, the variable will be set to false */
 		DBG_8712("CheckPbcGPIO - PBC is pressed !!!!\n");
 		/* 0 is the default value and it means the application monitors
-		 * the HW PBC doesn't privde its pid to driver. */
+		 * the HW PBC doesn't provide its pid to driver. */
 		if (padapter->pid == 0)
 			return;
 		kill_pid(find_vpid(padapter->pid), SIGUSR1, 1);
@@ -382,7 +382,7 @@ _next:
 			*pcmdbuf = cpu_to_le32((cmdsz & 0x0000ffff) |
 					       (pcmd->cmdcode << 16) |
 					       (pcmdpriv->cmd_seq << 24));
-			pcmdbuf += 2 ; /* 8 bytes aligment */
+			pcmdbuf += 2 ; /* 8 bytes alignment */
 			memcpy((u8 *)pcmdbuf, pcmd->parmbuf, pcmd->cmdsz);
 			while (check_cmd_fifo(padapter, wr_sz) == _FAIL) {
 				if ((padapter->bDriverStopped == true) ||
@@ -471,7 +471,7 @@ void r8712_event_handle(struct _adapter *padapter, uint *peventbuf)
 	pevt_priv->event_seq++;	/* update evt_seq */
 	if (pevt_priv->event_seq > 127)
 		pevt_priv->event_seq = 0;
-	peventbuf = peventbuf + 2; /* move to event content, 8 bytes aligment */
+	peventbuf = peventbuf + 2; /* move to event content, 8 bytes alignment */
 	if (peventbuf) {
 		event_callback = wlanevents[evt_code].event_callback;
 		if (event_callback)
diff --git a/drivers/staging/rtl8712/rtl8712_cmd.h b/drivers/staging/rtl8712/rtl8712_cmd.h
index 766a646..039ab3e 100644
--- a/drivers/staging/rtl8712/rtl8712_cmd.h
+++ b/drivers/staging/rtl8712/rtl8712_cmd.h
@@ -121,7 +121,7 @@ enum rtl8712_h2c_cmd {
 	GEN_CMD_CODE(_GetCurDataRate) ,
 
 	GEN_CMD_CODE(_GetTxRetrycnt),  /* to record times that Tx retry to
-					* transmmit packet after association
+					* transmit packet after association
 					*/
 	GEN_CMD_CODE(_GetRxRetrycnt),  /* to record total number of the
 					* received frame with ReTry bit set in
diff --git a/drivers/staging/rtl8712/rtl8712_efuse.c b/drivers/staging/rtl8712/rtl8712_efuse.c
index b08e9a2..377fca9 100644
--- a/drivers/staging/rtl8712/rtl8712_efuse.c
+++ b/drivers/staging/rtl8712/rtl8712_efuse.c
@@ -417,7 +417,7 @@ u8 r8712_efuse_pg_packet_write(struct _adapter *padapter, const u8 offset,
 		} else { /* write header fail */
 			bResult = false;
 			if (0xFF == efuse_data)
-				return bResult; /* not thing damaged. */
+				return bResult; /* nothing damaged. */
 			/* call rescue procedure */
 			if (fix_header(padapter, efuse_data, efuse_addr) ==
 			    false)
diff --git a/drivers/staging/rtl8712/rtl8712_gp_bitdef.h b/drivers/staging/rtl8712/rtl8712_gp_bitdef.h
index 884a821..138ea45 100644
--- a/drivers/staging/rtl8712/rtl8712_gp_bitdef.h
+++ b/drivers/staging/rtl8712/rtl8712_gp_bitdef.h
@@ -70,7 +70,7 @@
 #define		GPIOSEL_BT	2	/* BT_coex*/
 #define		GPIOSEL_WLANDBG	3	/* WLANDBG*/
 #define		GPIOSEL_GPIO_MASK	(~(BIT(0)|BIT(1)))
-/* HW Readio OFF switch (GPIO BIT) */
+/* HW Radio OFF switch (GPIO BIT) */
 #define		HAL_8192S_HW_GPIO_OFF_BIT	BIT(3)
 #define		HAL_8192S_HW_GPIO_OFF_MASK	0xF7
 #define		HAL_8192S_HW_GPIO_WPS_BIT	BIT(4)
diff --git a/drivers/staging/rtl8712/rtl8712_hal.h b/drivers/staging/rtl8712/rtl8712_hal.h
index d19865a..4c51fa3 100644
--- a/drivers/staging/rtl8712/rtl8712_hal.h
+++ b/drivers/staging/rtl8712/rtl8712_hal.h
@@ -83,7 +83,7 @@ struct fw_priv {   /*8-bytes alignment required*/
 	unsigned char rfintfs;    /* 0:SWSI, 1:HWSI, 2:HWPI*/
 	unsigned char def_nettype;
 	unsigned char turboMode;
-	unsigned char lowPowerMode;/* 0: noral mode, 1: low power mode*/
+	unsigned char lowPowerMode;/* 0: normal mode, 1: low power mode*/
 	/*--- long word 2 ----*/
 	unsigned char lbk_mode; /*0x00: normal, 0x03: MACLBK, 0x01: PHYLBK*/
 	unsigned char mp_mode; /* 1: for MP use, 0: for normal driver */
@@ -123,7 +123,7 @@ struct fw_priv {   /*8-bytes alignment required*/
 	unsigned char rsvd053;
 };
 
-struct fw_hdr {/*8-byte alinment required*/
+struct fw_hdr {/*8-byte alignment required*/
 	unsigned short	signature;
 	unsigned short	version;	/*0x8000 ~ 0x8FFF for FPGA version,
 					 *0x0000 ~ 0x7FFF for ASIC version,*/
diff --git a/drivers/staging/rtl8712/rtl8712_led.c b/drivers/staging/rtl8712/rtl8712_led.c
index bac56e5..c9eb4b7 100644
--- a/drivers/staging/rtl8712/rtl8712_led.c
+++ b/drivers/staging/rtl8712/rtl8712_led.c
@@ -60,7 +60,7 @@ enum _LED_STATE_871x {
 			     * the # of times to blink is depend on time
 			     * for scanning. */
 	LED_NO_LINK_BLINK = 7, /* LED is blinking during no link state. */
-	LED_BLINK_StartToBlink = 8,/* Customzied for Sercomm Printer
+	LED_BLINK_StartToBlink = 8,/* Customized for Sercomm Printer
 				    * Server case */
 	LED_BLINK_WPS = 9,	/* LED is blinkg during WPS communication */
 	LED_TXRX_BLINK = 10,
@@ -826,7 +826,7 @@ static void BlinkTimerCallback(unsigned long data)
 {
 	struct LED_871x  *pLed = (struct LED_871x *)data;
 
-	/* This fixed the crash problem on Fedora 12 when trying to do thei
+	/* This fixed the crash problem on Fedora 12 when trying to do the
 	 * insmod;ifconfig up;rmmod commands. */
 	if ((pLed->padapter->bSurpriseRemoved == true) ||
 	    (pLed->padapter->bDriverStopped == true))
@@ -836,7 +836,7 @@ static void BlinkTimerCallback(unsigned long data)
 
 /*	Description:
  *		Callback function of LED BlinkWorkItem.
- *		We dispatch acture LED blink action according to LedStrategy.
+ *		We dispatch actual LED blink action according to LedStrategy.
  */
 static void BlinkWorkItemCallback(struct work_struct *work)
 {
diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index fa6dc9c..5d7217f 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -459,7 +459,7 @@ void r8712_rxcmd_event_hdl(struct _adapter *padapter, void *prxcmdbuf)
 		cmd_seq = (u8)((le32_to_cpu(voffset) >> 24) & 0x7f);
 		eid = (u8)((le32_to_cpu(voffset) >> 16) & 0xff);
 		r8712_event_handle(padapter, (uint *)poffset);
-		poffset += (cmd_len + 8);/*8 bytes aligment*/
+		poffset += (cmd_len + 8);/*8 bytes alignment*/
 	} while (le32_to_cpu(voffset) & BIT(31));
 
 }
@@ -603,7 +603,7 @@ static int recv_indicatepkt_reorder(struct _adapter *padapter,
 		}
 	}
 	spin_lock_irqsave(&ppending_recvframe_queue->lock, irql);
-	/*s2. check if winstart_b(indicate_seq) needs to been updated*/
+	/*s2. check if winstart_b(indicate_seq) needs to be updated*/
 	if (!check_indicate_seq(preorder_ctrl, pattrib->seq_num))
 		goto _err_exit;
 	/*s3. Insert all packet into Reorder Queue to maintain its ordering.*/
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.h b/drivers/staging/rtl8712/rtl871x_cmd.h
index 757ebf7..9d93189 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.h
+++ b/drivers/staging/rtl8712/rtl871x_cmd.h
@@ -720,7 +720,7 @@ struct DisconnectCtrlEx_param {
  * Result:
  * 0x00: success
  * 0x01: success, and check Response.
- * 0x02: cmd ignored due to duplicated sequcne number
+ * 0x02: cmd ignored due to duplicated sequence number
  * 0x03: cmd dropped due to invalid cmd code
  * 0x04: reserved.
  */
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index 3b23bef..35e781f 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -241,7 +241,7 @@ static inline char *translate_scan(struct _adapter *padapter,
 	/* Add frequency/channel */
 	iwe.cmd = SIOCGIWFREQ;
 	{
-		/*  check legel index */
+		/*  check legal index */
 		u8 dsconfig = pnetwork->network.Configuration.DSConfig;
 		if (dsconfig >= 1 && dsconfig <= sizeof(
 		    ieee80211_wlan_frequencies) / sizeof(long))
@@ -809,11 +809,11 @@ static int r871x_wx_set_pmkid(struct net_device *dev,
 
 /*
 	There are the BSSID information in the bssid.sa_data array.
-	If cmd is IW_PMKSA_FLUSH, it means the wpa_suppplicant wants to clear
-	 all the PMKID information. If cmd is IW_PMKSA_ADD, it means the
-	  wpa_supplicant wants to add a PMKID/BSSID to driver.
+	If cmd is IW_PMKSA_FLUSH, it means the wpa_supplicant wants to clear
+	all the PMKID information. If cmd is IW_PMKSA_ADD, it means the
+	wpa_supplicant wants to add a PMKID/BSSID to driver.
 	If cmd is IW_PMKSA_REMOVE, it means the wpa_supplicant wants to
-	  remove a PMKID/BSSID from driver.
+	remove a PMKID/BSSID from driver.
 */
 	if (pPMK == NULL)
 		return -EINVAL;
@@ -923,7 +923,7 @@ static int r8711_wx_get_range(struct net_device *dev,
 	range->max_qual.noise = 100;
 	range->max_qual.updated = 7; /* Updated all three */
 	range->avg_qual.qual = 92; /* > 8% missed beacons is 'bad' */
-	/* TODO: Find real 'good' to 'bad' threshol value for RSSI */
+	/* TODO: Find real 'good' to 'bad' threshold value for RSSI */
 	range->avg_qual.level = 20 + -98;
 	range->avg_qual.noise = 0;
 	range->avg_qual.updated = 7; /* Updated all three */
@@ -1070,7 +1070,7 @@ FREE_EXT:
  * MAC# of a preferred Access Point.
  * Currently, the request comes via Wireless Extensions' SIOCSIWAP ioctl.
  *
- * For this operation to succeed, there is no need for the interface to be Up.
+ * For this operation to succeed, there is no need for the interface to be up.
  *
  */
 static int r8711_wx_set_wap(struct net_device *dev,
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_set.c b/drivers/staging/rtl8712/rtl871x_ioctl_set.c
index fb29b42..f352b32 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_set.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_set.c
@@ -264,7 +264,7 @@ void r8712_set_802_11_infrastructure_mode(struct _adapter *padapter,
 		    (*pold_state == Ndis802_11Infrastructure) ||
 		    (*pold_state == Ndis802_11IBSS)) {
 			/* will clr Linked_state before this function,
-			 * we must have chked whether issue dis-assoc_cmd or
+			 * we must have checked whether issue dis-assoc_cmd or
 			 * not */
 			r8712_ind_disconnect(padapter);
 		}
diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index 4277d03..dc7adc1 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -137,7 +137,7 @@ static void _free_network_nolock(struct mlme_priv *pmlmepriv,
 
 /*
 	return the wlan_network with the matching addr
-	Shall be calle under atomic context...
+	Shall be called under atomic context...
 	to avoid possible racing condition...
 */
 static struct wlan_network *_r8712_find_network(struct  __queue *scanned_queue,
@@ -255,7 +255,7 @@ void r8712_free_network_queue(struct _adapter *dev)
 /*
 	return the wlan_network with the matching addr
 
-	Shall be calle under atomic context...
+	Shall be called under atomic context...
 	to avoid possible racing condition...
 */
 static struct wlan_network *r8712_find_network(struct  __queue *scanned_queue,
@@ -1037,7 +1037,7 @@ void r8712_cpwm_event_callback(struct _adapter *adapter, u8 *pbuf)
  *	 and the WiFi client will drop the data with seq number 0.
  *	So, the 8712 firmware has to inform driver with receiving the
  *	 ADDBA-Req frame so that the driver can reset the
- *	sequence value of Rx reorder contorl.
+ *	sequence value of Rx reorder control.
  */
 void r8712_got_addbareq_event_callback(struct _adapter *adapter, u8 *pbuf)
 {
@@ -1775,7 +1775,7 @@ static void update_ht_cap(struct _adapter *padapter, u8 *pie, uint ie_len)
 		phtpriv->rx_ampdu_maxlen = max_ampdu_sz;
 	}
 	/* for A-MPDU Rx reordering buffer control for bmc_sta & sta_info
-	 * if A-MPDU Rx is enabled, reseting rx_ordering_ctrl
+	 * if A-MPDU Rx is enabled, resetting rx_ordering_ctrl
 	 * wstart_b(indicate_seq) to default value=0xffff
 	 * todo: check if AP can send A-MPDU packets
 	 */
diff --git a/drivers/staging/rtl8712/rtl871x_mlme.h b/drivers/staging/rtl8712/rtl871x_mlme.h
index 71ca013..42bd0bf 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.h
+++ b/drivers/staging/rtl8712/rtl871x_mlme.h
@@ -69,8 +69,8 @@ since mlme_priv is a shared resource between many threads,
 like ISR/Call-Back functions, the OID handlers, and even timer functions.
 Each _queue has its own locks, already.
 Other items are protected by mlme_priv.lock.
-To avoid possible dead lock, any thread trying to modifiying mlme_priv
-SHALL not lock up more than one locks at a time!
+To avoid possible dead lock, any thread trying to modify mlme_priv
+SHALL not lock up more than one lock at a time!
 */
 
 #define traffic_threshold	10
@@ -132,7 +132,7 @@ static inline sint get_fwstate(struct mlme_priv *pmlmepriv)
  * therefore set it to be the critical section...
  *
  * ### NOTE:#### (!!!!)
- * TAKE CARE THAT BEFORE CALLING THIS FUNC, LOCK pmlmepriv->lock
+ * TAKE CARE BEFORE CALLING THIS FUNC, LOCK pmlmepriv->lock
  */
 static inline void set_fwstate(struct mlme_priv *pmlmepriv, sint state)
 {
diff --git a/drivers/staging/rtl8712/rtl871x_mp_phy_regdef.h b/drivers/staging/rtl8712/rtl871x_mp_phy_regdef.h
index 23532a7..8e25862 100644
--- a/drivers/staging/rtl8712/rtl871x_mp_phy_regdef.h
+++ b/drivers/staging/rtl8712/rtl871x_mp_phy_regdef.h
@@ -184,7 +184,7 @@
 
 /*RxIQ DC offset, Rx digital filter, DC notch filter */
 #define	rOFDM0_XARxAFE			0xc10
-#define	rOFDM0_XARxIQImbalance		0xc14  /* RxIQ imblance matrix */
+#define	rOFDM0_XARxIQImbalance		0xc14  /* RxIQ imbalance matrix */
 #define	rOFDM0_XBRxAFE			0xc18
 #define	rOFDM0_XBRxIQImbalance		0xc1c
 #define	rOFDM0_XCRxAFE			0xc20
@@ -603,7 +603,7 @@
 #define	bCCKRxIG		0x7f00
 #define	bCCKLNAPolarity		0x800000
 #define	bCCKRx1stGain		0x7f0000
-#define	bCCKRFExtend		0x20000000 /* CCK Rx Iinital gain polarity */
+#define	bCCKRFExtend		0x20000000 /* CCK Rx inital gain polarity */
 #define	bCCKRxAGCSatLevel	0x1f000000
 #define	bCCKRxAGCSatCount       0xe0
 #define	bCCKRxRFSettle          0x1f       /* AGCsamp_dly */
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.c b/drivers/staging/rtl8712/rtl871x_xmit.c
index aa57e77..2ddb757 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.c
+++ b/drivers/staging/rtl8712/rtl871x_xmit.c
@@ -72,7 +72,7 @@ sint _r8712_init_xmit_priv(struct xmit_priv *pxmitpriv,
 	memset((unsigned char *)pxmitpriv, 0, sizeof(struct xmit_priv));
 	spin_lock_init(&pxmitpriv->lock);
 	/*
-	Please insert all the queue initializaiton using _init_queue below
+	Please insert all the queue initialization using _init_queue below
 	*/
 	pxmitpriv->adapter = padapter;
 	_init_queue(&pxmitpriv->be_pending);
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.h b/drivers/staging/rtl8712/rtl871x_xmit.h
index 638b79b..ee90698 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.h
+++ b/drivers/staging/rtl8712/rtl871x_xmit.h
@@ -119,7 +119,7 @@ struct pkt_attrib {
 
 	u8	priority;
 	u8	encrypt;	/* when 0 indicate no encrypt. when non-zero,
-				 * indicate the encrypt algorith*/
+				 * indicate the encrypt algorithm*/
 	u8	iv_len;
 	u8	icv_len;
 	unsigned char iv[8];
diff --git a/drivers/staging/rtl8712/usb_halinit.c b/drivers/staging/rtl8712/usb_halinit.c
index 46287c1..b4ae11a 100644
--- a/drivers/staging/rtl8712/usb_halinit.c
+++ b/drivers/staging/rtl8712/usb_halinit.c
@@ -141,7 +141,7 @@ u8 r8712_usb_hal_bus_init(struct _adapter *padapter)
 		/* Enable AFE PLL Macro Block */
 		val8 = r8712_read8(padapter, AFE_PLL_CTRL);
 		r8712_write8(padapter, AFE_PLL_CTRL, (val8 | 0x11));
-		/* Attatch AFE PLL to MACTOP/BB/PCIe Digital */
+		/* Attach AFE PLL to MACTOP/BB/PCIe Digital */
 		val8 = r8712_read8(padapter, SYS_ISO_CTRL);
 		r8712_write8(padapter, SYS_ISO_CTRL, (val8 & 0xEE));
 		/* Switch to 40M clock */
@@ -234,7 +234,7 @@ u8 r8712_usb_hal_bus_init(struct _adapter *padapter)
 		udelay(500);
 		r8712_write8(padapter, AFE_PLL_CTRL, (val8 | 0x11));
 		udelay(500);
-		/* Attatch AFE PLL to MACTOP/BB/PCIe Digital */
+		/* Attach AFE PLL to MACTOP/BB/PCIe Digital */
 		val8 = r8712_read8(padapter, SYS_ISO_CTRL);
 		r8712_write8(padapter, SYS_ISO_CTRL, (val8 & 0xEE));
 		/* Switch to 40M clock */
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index e419b4f..a0de043 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -644,7 +644,7 @@ static void r871xu_dev_remove(struct usb_interface *pusb_intf)
 	/* decrease the reference count of the usb device structure
 	 * when disconnect */
 	usb_put_dev(udev);
-	/* If we didn't unplug usb dongle and remove/insert modlue, driver
+	/* If we didn't unplug usb dongle and remove/insert module, driver
 	 * fails on sitesurvey for the first time when device is up.
 	 * Reset usb port for sitesurvey fail issue. */
 	if (udev->state != USB_STATE_NOTATTACHED)
-- 
1.7.5.4

