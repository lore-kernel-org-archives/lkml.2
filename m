Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab1DBBB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 21:01:59 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:56760 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab1DBBB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 21:01:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAOd0lk1bdWOb/2dsb2JhbACmWcB1hWsEjSE
X-IronPort-AV: E=Sophos;i="4.63,285,1299452400"; 
   d="scan'208";a="825581143"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com
Cc: linux-kernel@vger.kernel.org, "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 1/2] staging: rtl8712: fixed coding style issues
Date: Sat,  2 Apr 2011 03:01:49 +0200
Message-Id: <1301706109-4553-1-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some style and format issues with headers.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/rtl8712/ieee80211.h         |   26 ++--
 drivers/staging/rtl8712/if_ether.h          |    4 +-
 drivers/staging/rtl8712/ip.h                |   34 ++--
 drivers/staging/rtl8712/mlme_osdep.h        |    4 +-
 drivers/staging/rtl8712/osdep_service.h     |    3 +-
 drivers/staging/rtl8712/recv_osdep.h        |    4 +-
 drivers/staging/rtl8712/rtl8712_event.h     |   25 ++--
 drivers/staging/rtl8712/rtl8712_hal.h       |  100 +++++++-------
 drivers/staging/rtl8712/rtl8712_recv.h      |    2 +-
 drivers/staging/rtl8712/rtl8712_xmit.h      |   11 +--
 drivers/staging/rtl8712/rtl871x_cmd.h       |   26 ++--
 drivers/staging/rtl8712/rtl871x_event.h     |   12 +-
 drivers/staging/rtl8712/rtl871x_ioctl_set.h |   16 ++-
 drivers/staging/rtl8712/rtl871x_mp_ioctl.h  |   10 +-
 drivers/staging/rtl8712/rtl871x_recv.h      |    4 +-
 drivers/staging/rtl8712/rtl871x_rf.h        |    2 +-
 drivers/staging/rtl8712/rtl871x_security.h  |   51 ++++---
 drivers/staging/rtl8712/rtl871x_xmit.h      |    3 +-
 drivers/staging/rtl8712/wifi.h              |   63 ++++-----
 drivers/staging/rtl8712/wlan_bssdef.h       |  212 +++++++++++++-------------
 20 files changed, 306 insertions(+), 306 deletions(-)

diff --git a/drivers/staging/rtl8712/ieee80211.h b/drivers/staging/rtl8712/ieee80211.h
index 432cf8a..1f4d147 100644
--- a/drivers/staging/rtl8712/ieee80211.h
+++ b/drivers/staging/rtl8712/ieee80211.h
@@ -76,7 +76,7 @@ struct ieee_param {
 			u8 reserved[32];
 			u8 data[0];
 		} wpa_ie;
-		struct{
+		struct {
 			int command;
 			int reason_code;
 		} mlme;
@@ -149,11 +149,11 @@ struct	ieee80211_hdr_qos {
 struct  ieee80211_hdr_3addr_qos {
 	u16 frame_ctl;
 	u16 duration_id;
-	u8 addr1[ETH_ALEN];
-	u8 addr2[ETH_ALEN];
-	u8 addr3[ETH_ALEN];
+	u8  addr1[ETH_ALEN];
+	u8  addr2[ETH_ALEN];
+	u8  addr3[ETH_ALEN];
 	u16 seq_ctl;
-       u16     qc;
+	u16 qc;
 }  __attribute__ ((packed));
 
 struct eapol {
@@ -461,7 +461,7 @@ struct ieee80211_stats {
 	uint rx_message_in_bad_msg_fragments;
 };
 
-struct ieee80211_softmac_stats{
+struct ieee80211_softmac_stats {
 	uint rx_ass_ok;
 	uint rx_ass_err;
 	uint rx_probe_rq;
@@ -754,15 +754,17 @@ struct registry_priv;
 u8 *r8712_set_ie(u8 *pbuf, sint index, uint len, u8 *source, uint *frlen);
 u8 *r8712_get_ie(u8*pbuf, sint index, sint *len, sint limit);
 unsigned char *r8712_get_wpa_ie(unsigned char *pie, int *rsn_ie_len, int limit);
-unsigned char *r8712_get_wpa2_ie(unsigned char *pie, int *rsn_ie_len, int limit);
+unsigned char *r8712_get_wpa2_ie(unsigned char *pie, int *rsn_ie_len,
+				 int limit);
 int r8712_parse_wpa_ie(u8 *wpa_ie, int wpa_ie_len, int *group_cipher,
-		       int *pairwise_cipher);
+			int *pairwise_cipher);
 int r8712_parse_wpa2_ie(u8 *wpa_ie, int wpa_ie_len, int *group_cipher,
-		        int *pairwise_cipher);
-int r8712_get_sec_ie(u8 *in_ie, uint in_len, u8 *rsn_ie, u16 *rsn_len, u8 *wpa_ie,
-	       u16 *wpa_len);
+			int *pairwise_cipher);
+int r8712_get_sec_ie(u8 *in_ie, uint in_len, u8 *rsn_ie, u16 *rsn_len,
+		     u8 *wpa_ie, u16 *wpa_len);
 int r8712_get_wps_ie(u8 *in_ie, uint in_len, u8 *wps_ie, uint *wps_ielen);
-int r8712_generate_ie(struct registry_priv *pregistrypriv, struct _adapter *padapter);
+int r8712_generate_ie(struct registry_priv *pregistrypriv,
+		      struct _adapter *padapter);
 uint r8712_is_cckrates_included(u8 *rate);
 uint r8712_is_cckratesonly_included(u8 *rate);
 
diff --git a/drivers/staging/rtl8712/if_ether.h b/drivers/staging/rtl8712/if_ether.h
index 36a2ba5..0e9753b 100644
--- a/drivers/staging/rtl8712/if_ether.h
+++ b/drivers/staging/rtl8712/if_ether.h
@@ -99,8 +99,8 @@ struct ethhdr {
 };
 
 struct _vlan {
-   unsigned short       h_vlan_TCI;	/* Encapsulates priority and VLAN ID*/
-   unsigned short       h_vlan_encapsulated_proto;
+	unsigned short  h_vlan_TCI;	/* Encapsulates priority and VLAN ID*/
+	unsigned short  h_vlan_encapsulated_proto;
 };
 
 
diff --git a/drivers/staging/rtl8712/ip.h b/drivers/staging/rtl8712/ip.h
index 4785a59..f37b0f8 100644
--- a/drivers/staging/rtl8712/ip.h
+++ b/drivers/staging/rtl8712/ip.h
@@ -90,23 +90,23 @@
 #define	IPOPT_TS_PRESPEC	3		/* specified modules only */
 
 struct ip_options {
-  __u32		faddr;				/* Saved first hop address */
-  unsigned char	optlen;
-  unsigned char srr;
-  unsigned char rr;
-  unsigned char ts;
-  unsigned char is_setbyuser:1,	/* Set by setsockopt?			*/
-		is_data:1,	/* Options in __data, rather than skb	*/
-		is_strictroute:1, /* Strict source route		*/
-		srr_is_hit:1,	/* Packet destination addr was our one	*/
-		is_changed:1,	/* IP checksum more not valid		*/
-		rr_needaddr:1,	/* Need to record addr of outgoing dev	*/
-		ts_needtime:1,	/* Need to record timestamp		*/
-		ts_needaddr:1;	/* Need to record addr of outgoing dev  */
-  unsigned char router_alert;
-  unsigned char __pad1;
-  unsigned char __pad2;
-  unsigned char __data[0];
+	__u32		faddr;			/* Saved first hop address */
+	unsigned char	optlen;
+	unsigned char srr;
+	unsigned char rr;
+	unsigned char ts;
+	unsigned char is_setbyuser:1,	/* Set by setsockopt?		      */
+		      is_data:1,	/* Options in __data, rather than skb */
+		      is_strictroute:1, /* Strict source route		      */
+		      srr_is_hit:1,	/* Packet destination addr was our one*/
+		      is_changed:1,	/* IP checksum more not valid	      */
+		      rr_needaddr:1,	/* Need to record addr of outgoing dev*/
+		      ts_needtime:1,	/* Need to record timestamp	      */
+		      ts_needaddr:1;	/* Need to record addr of outgoing dev*/
+	unsigned char router_alert;
+	unsigned char __pad1;
+	unsigned char __pad2;
+	unsigned char __data[0];
 };
 
 #define optlength(opt) (sizeof(struct ip_options) + opt->optlen)
diff --git a/drivers/staging/rtl8712/mlme_osdep.h b/drivers/staging/rtl8712/mlme_osdep.h
index 7013a49..968e787 100644
--- a/drivers/staging/rtl8712/mlme_osdep.h
+++ b/drivers/staging/rtl8712/mlme_osdep.h
@@ -9,8 +9,8 @@ void r8712_os_indicate_disconnect(struct _adapter *adapter);
 void r8712_os_indicate_connect(struct _adapter *adapter);
 void r8712_report_sec_ie(struct _adapter *adapter, u8 authmode, u8 *sec_ie);
 int r8712_recv_indicatepkts_in_order(struct _adapter *adapter,
-				     struct recv_reorder_ctrl *precvreorder_ctrl,
-				     int bforced);
+				struct recv_reorder_ctrl *precvreorder_ctrl,
+				int bforced);
 void r8712_indicate_wx_assoc_event(struct _adapter *padapter);
 void r8712_indicate_wx_disassoc_event(struct _adapter *padapter);
 
diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 36eeb5a..3d3f73c 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -145,7 +145,8 @@ static inline u32 is_list_empty(struct list_head *phead)
 		return false;
 }
 
-static inline void list_insert_tail(struct list_head *plist, struct list_head *phead)
+static inline void list_insert_tail(struct list_head *plist,
+				    struct list_head *phead)
 {
 	list_add_tail(plist, phead);
 }
diff --git a/drivers/staging/rtl8712/recv_osdep.h b/drivers/staging/rtl8712/recv_osdep.h
index b23dd6b..60a54dd 100644
--- a/drivers/staging/rtl8712/recv_osdep.h
+++ b/drivers/staging/rtl8712/recv_osdep.h
@@ -12,7 +12,8 @@ s32  r8712_recv_entry(union recv_frame *precv_frame);
 void r8712_recv_indicatepkt(struct _adapter *adapter,
 			    union recv_frame *precv_frame);
 void r8712_handle_tkip_mic_err(struct _adapter *padapter, u8 bgroup);
-int r8712_init_recv_priv(struct recv_priv *precvpriv, struct _adapter *padapter);
+int r8712_init_recv_priv(struct recv_priv *precvpriv,
+			 struct _adapter *padapter);
 void r8712_free_recv_priv(struct recv_priv *precvpriv);
 int r8712_os_recv_resource_alloc(struct _adapter *padapter,
 				 union recv_frame *precvframe);
@@ -24,4 +25,3 @@ void r8712_os_read_port(struct _adapter *padapter, struct recv_buf *precvbuf);
 void r8712_init_recv_timer(struct recv_reorder_ctrl *preorder_ctrl);
 
 #endif
-
diff --git a/drivers/staging/rtl8712/rtl8712_event.h b/drivers/staging/rtl8712/rtl8712_event.h
index 48408f7..2731693 100644
--- a/drivers/staging/rtl8712/rtl8712_event.h
+++ b/drivers/staging/rtl8712/rtl8712_event.h
@@ -5,33 +5,33 @@ void r8712_event_handle(struct _adapter *padapter, uint *peventbuf);
 void r8712_got_addbareq_event_callback(struct _adapter *adapter , u8 *pbuf);
 
 enum rtl8712_c2h_event {
-	GEN_EVT_CODE(_Read_MACREG) = 0, /*0*/
+	GEN_EVT_CODE(_Read_MACREG) = 0,		/*0*/
 	GEN_EVT_CODE(_Read_BBREG),
 	GEN_EVT_CODE(_Read_RFREG),
 	GEN_EVT_CODE(_Read_EEPROM),
 	GEN_EVT_CODE(_Read_EFUSE),
-	GEN_EVT_CODE(_Read_CAM),			/*5*/
+	GEN_EVT_CODE(_Read_CAM),		/*5*/
 	GEN_EVT_CODE(_Get_BasicRate),
 	GEN_EVT_CODE(_Get_DataRate),
-	GEN_EVT_CODE(_Survey),	 /*8*/
-	GEN_EVT_CODE(_SurveyDone),	 /*9*/
+	GEN_EVT_CODE(_Survey),			/*8*/
+	GEN_EVT_CODE(_SurveyDone),		/*9*/
 
-	GEN_EVT_CODE(_JoinBss) , /*10*/
+	GEN_EVT_CODE(_JoinBss),			/*10*/
 	GEN_EVT_CODE(_AddSTA),
 	GEN_EVT_CODE(_DelSTA),
-	GEN_EVT_CODE(_AtimDone) ,
+	GEN_EVT_CODE(_AtimDone),
 	GEN_EVT_CODE(_TX_Report),
-	GEN_EVT_CODE(_CCX_Report),			/*15*/
+	GEN_EVT_CODE(_CCX_Report),		/*15*/
 	GEN_EVT_CODE(_DTM_Report),
 	GEN_EVT_CODE(_TX_Rate_Statistics),
 	GEN_EVT_CODE(_C2HLBK),
 	GEN_EVT_CODE(_FWDBG),
-	GEN_EVT_CODE(_C2HFEEDBACK),               /*20*/
+	GEN_EVT_CODE(_C2HFEEDBACK),		/*20*/
 	GEN_EVT_CODE(_ADDBA),
 	GEN_EVT_CODE(_C2HBCN),
 	GEN_EVT_CODE(_ReportPwrState),		/*filen: only for PCIE, USB*/
 	GEN_EVT_CODE(_WPS_PBC),			/*24*/
-	GEN_EVT_CODE(_ADDBAReq_Report),	/*25*/
+	GEN_EVT_CODE(_ADDBAReq_Report),		/*25*/
 	MAX_C2HEVT
 };
 
@@ -48,7 +48,8 @@ static struct fwevent wlanevents[] = {
 	{0, NULL},
 	{0, NULL},
 	{0, &r8712_survey_event_callback},		/*8*/
-	{sizeof(struct surveydone_event), &r8712_surveydone_event_callback},/*9*/
+	{sizeof(struct surveydone_event),
+		&r8712_surveydone_event_callback},	/*9*/
 
 	{0, &r8712_joinbss_event_callback},		/*10*/
 	{sizeof(struct stassoc_event), &r8712_stassoc_event_callback},
@@ -59,8 +60,8 @@ static struct fwevent wlanevents[] = {
 	{0, NULL},
 	{0, NULL},
 	{0, NULL},
-	{0, NULL}, /*fwdbg_event_callback},*/
-	{0, NULL},	 /*20*/
+	{0, NULL},	/*fwdbg_event_callback},*/
+	{0, NULL},	/*20*/
 	{0, NULL},
 	{0, NULL},
 	{0, &r8712_cpwm_event_callback},
diff --git a/drivers/staging/rtl8712/rtl8712_hal.h b/drivers/staging/rtl8712/rtl8712_hal.h
index 13df200..66baa87 100644
--- a/drivers/staging/rtl8712/rtl8712_hal.h
+++ b/drivers/staging/rtl8712/rtl8712_hal.h
@@ -21,13 +21,13 @@ enum RTL871X_HCI_TYPE {
 	RTL8712_USB,
 };
 
-enum RTL8712_RF_CONFIG{
+enum RTL8712_RF_CONFIG {
 	RTL8712_RF_1T1R,
 	RTL8712_RF_1T2R,
 	RTL8712_RF_2T2R
 };
 
-enum _RTL8712_HCI_TYPE_{
+enum _RTL8712_HCI_TYPE_ {
 	RTL8712_HCI_TYPE_PCIE = 0x01,
 	RTL8712_HCI_TYPE_AP_PCIE = 0x81,
 	RTL8712_HCI_TYPE_USB = 0x02,
@@ -40,62 +40,62 @@ enum _RTL8712_HCI_TYPE_{
 
 struct fw_priv {   /*8-bytes alignment required*/
 	/*--- long word 0 ----*/
- unsigned char  signature_0;  /*0x12: CE product, 0x92: IT product*/
- unsigned char  signature_1;  /*0x87: CE product, 0x81: IT product*/
- unsigned char  hci_sel;   /*0x81: PCI-AP, 01:PCIe, 02: 92S-U, 0x82: USB-AP,
+	unsigned char signature_0;  /*0x12: CE product, 0x92: IT product*/
+	unsigned char signature_1;  /*0x87: CE product, 0x81: IT product*/
+	unsigned char hci_sel; /*0x81: PCI-AP, 01:PCIe, 02: 92S-U, 0x82: USB-AP,
 			    * 0x12: 72S-U, 03:SDIO*/
- unsigned char  chip_version; /*the same value as register value*/
- unsigned char  customer_ID_0; /*customer  ID low byte*/
- unsigned char  customer_ID_1; /*customer  ID high byte*/
- unsigned char  rf_config;  /*0x11:  1T1R, 0x12: 1T2R, 0x92: 1T2R turbo,
+	unsigned char chip_version; /*the same value as register value*/
+	unsigned char customer_ID_0; /*customer  ID low byte*/
+	unsigned char customer_ID_1; /*customer  ID high byte*/
+	unsigned char rf_config;  /*0x11:  1T1R, 0x12: 1T2R, 0x92: 1T2R turbo,
 			     * 0x22: 2T2R*/
- unsigned char  usb_ep_num;  /* 4: 4EP, 6: 6EP, 11: 11EP*/
+	unsigned char usb_ep_num;  /* 4: 4EP, 6: 6EP, 11: 11EP*/
 	/*--- long word 1 ----*/
- unsigned char  regulatory_class_0; /*regulatory class bit map 0*/
- unsigned char  regulatory_class_1; /*regulatory class bit map 1*/
- unsigned char  regulatory_class_2; /*regulatory class bit map 2*/
- unsigned char  regulatory_class_3; /*regulatory class bit map 3*/
- unsigned char  rfintfs;    /* 0:SWSI, 1:HWSI, 2:HWPI*/
- unsigned char  def_nettype;
- unsigned char  turboMode;
- unsigned char  lowPowerMode;/* 0: noral mode, 1: low power mode*/
+	unsigned char regulatory_class_0; /*regulatory class bit map 0*/
+	unsigned char regulatory_class_1; /*regulatory class bit map 1*/
+	unsigned char regulatory_class_2; /*regulatory class bit map 2*/
+	unsigned char regulatory_class_3; /*regulatory class bit map 3*/
+	unsigned char rfintfs;    /* 0:SWSI, 1:HWSI, 2:HWPI*/
+	unsigned char def_nettype;
+	unsigned char turboMode;
+	unsigned char lowPowerMode;/* 0: noral mode, 1: low power mode*/
 	/*--- long word 2 ----*/
- unsigned char  lbk_mode; /*0x00: normal, 0x03: MACLBK, 0x01: PHYLBK*/
- unsigned char  mp_mode; /* 1: for MP use, 0: for normal driver */
- unsigned char  vcsType; /* 0:off 1:on 2:auto */
- unsigned char  vcsMode; /* 1:RTS/CTS 2:CTS to self */
- unsigned char  rsvd022;
- unsigned char  rsvd023;
- unsigned char  rsvd024;
- unsigned char  rsvd025;
+	unsigned char lbk_mode; /*0x00: normal, 0x03: MACLBK, 0x01: PHYLBK*/
+	unsigned char mp_mode; /* 1: for MP use, 0: for normal driver */
+	unsigned char vcsType; /* 0:off 1:on 2:auto */
+	unsigned char vcsMode; /* 1:RTS/CTS 2:CTS to self */
+	unsigned char rsvd022;
+	unsigned char rsvd023;
+	unsigned char rsvd024;
+	unsigned char rsvd025;
 	/*--- long word 3 ----*/
- unsigned char  qos_en;    /*1: QoS enable*/
- unsigned char  bw_40MHz_en;   /*1: 40MHz BW enable*/
- unsigned char  AMSDU2AMPDU_en;   /*1: 4181 convert AMSDU to AMPDU,
+	unsigned char qos_en;    /*1: QoS enable*/
+	unsigned char bw_40MHz_en;   /*1: 40MHz BW enable*/
+	unsigned char AMSDU2AMPDU_en;   /*1: 4181 convert AMSDU to AMPDU,
 				   * 0: disable*/
- unsigned char  AMPDU_en;   /*1: 11n AMPDU enable*/
- unsigned char  rate_control_offload;  /*1: FW offloads, 0: driver handles*/
- unsigned char  aggregation_offload;  /*1: FW offloads, 0: driver handles*/
- unsigned char  rsvd030;
- unsigned char  rsvd031;
+	unsigned char AMPDU_en;   /*1: 11n AMPDU enable*/
+	unsigned char rate_control_offload; /*1: FW offloads,0: driver handles*/
+	unsigned char aggregation_offload;  /*1: FW offloads,0: driver handles*/
+	unsigned char rsvd030;
+	unsigned char rsvd031;
 	/*--- long word 4 ----*/
- unsigned char  beacon_offload;   /* 1. FW offloads, 0: driver handles*/
- unsigned char  MLME_offload;   /* 2. FW offloads, 0: driver handles*/
- unsigned char  hwpc_offload;   /* 3. FW offloads, 0: driver handles*/
- unsigned char  tcp_checksum_offload; /* 4. FW offloads, 0: driver handles*/
- unsigned char  tcp_offload;    /* 5. FW offloads, 0: driver handles*/
- unsigned char  ps_control_offload;  /* 6. FW offloads, 0: driver handles*/
- unsigned char  WWLAN_offload;   /* 7. FW offloads, 0: driver handles*/
- unsigned char  rsvd040;
+	unsigned char beacon_offload;   /* 1. FW offloads, 0: driver handles*/
+	unsigned char MLME_offload;   /* 2. FW offloads, 0: driver handles*/
+	unsigned char hwpc_offload;   /* 3. FW offloads, 0: driver handles*/
+	unsigned char tcp_checksum_offload; /*4. FW offloads,0: driver handles*/
+	unsigned char tcp_offload;    /* 5. FW offloads, 0: driver handles*/
+	unsigned char ps_control_offload; /* 6. FW offloads, 0: driver handles*/
+	unsigned char WWLAN_offload;   /* 7. FW offloads, 0: driver handles*/
+	unsigned char rsvd040;
 	/*--- long word 5 ----*/
- unsigned char  tcp_tx_frame_len_L;  /*tcp tx packet length low byte*/
- unsigned char  tcp_tx_frame_len_H;  /*tcp tx packet length high byte*/
- unsigned char  tcp_rx_frame_len_L;  /*tcp rx packet length low byte*/
- unsigned char  tcp_rx_frame_len_H;  /*tcp rx packet length high byte*/
- unsigned char  rsvd050;
- unsigned char  rsvd051;
- unsigned char  rsvd052;
- unsigned char  rsvd053;
+	unsigned char tcp_tx_frame_len_L;  /*tcp tx packet length low byte*/
+	unsigned char tcp_tx_frame_len_H;  /*tcp tx packet length high byte*/
+	unsigned char tcp_rx_frame_len_L;  /*tcp rx packet length low byte*/
+	unsigned char tcp_rx_frame_len_H;  /*tcp rx packet length high byte*/
+	unsigned char rsvd050;
+	unsigned char rsvd051;
+	unsigned char rsvd052;
+	unsigned char rsvd053;
 };
 
 struct fw_hdr {/*8-byte alinment required*/
diff --git a/drivers/staging/rtl8712/rtl8712_recv.h b/drivers/staging/rtl8712/rtl8712_recv.h
index 4ba52b9..c48757f 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.h
+++ b/drivers/staging/rtl8712/rtl8712_recv.h
@@ -93,7 +93,7 @@ struct recv_buf {
 	end   ----->
 	len = (unsigned int )(tail - data);
 */
-struct recv_frame_hdr{
+struct recv_frame_hdr {
 	struct list_head list;
 	_pkt	*pkt;
 	_pkt *pkt_newalloc;
diff --git a/drivers/staging/rtl8712/rtl8712_xmit.h b/drivers/staging/rtl8712/rtl8712_xmit.h
index 5d77c51..12a080f 100644
--- a/drivers/staging/rtl8712/rtl8712_xmit.h
+++ b/drivers/staging/rtl8712/rtl8712_xmit.h
@@ -59,25 +59,16 @@
 /*OFFSET 20*/
 #define DISFB BIT(15)
 
-struct tx_desc{
-
+struct tx_desc {
 	/*DWORD 0*/
 	unsigned int txdw0;
-
 	unsigned int txdw1;
-
 	unsigned int txdw2;
-
 	unsigned int txdw3;
-
 	unsigned int txdw4;
-
 	unsigned int txdw5;
-
 	unsigned int txdw6;
-
 	unsigned int txdw7;
-
 };
 
 
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.h b/drivers/staging/rtl8712/rtl871x_cmd.h
index 3a945b5..5e4ee47 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.h
+++ b/drivers/staging/rtl8712/rtl871x_cmd.h
@@ -562,54 +562,54 @@ struct getratable_rsp {
 };
 
 /*to get TX,RX retry count*/
-struct gettxretrycnt_parm{
+struct gettxretrycnt_parm {
 	unsigned int rsvd;
 };
 
-struct gettxretrycnt_rsp{
+struct gettxretrycnt_rsp {
 	unsigned long tx_retrycnt;
 };
 
-struct getrxretrycnt_parm{
+struct getrxretrycnt_parm {
 	unsigned int rsvd;
 };
 
-struct getrxretrycnt_rsp{
+struct getrxretrycnt_rsp {
 	unsigned long rx_retrycnt;
 };
 
 /*to get BCNOK,BCNERR count*/
-struct getbcnokcnt_parm{
+struct getbcnokcnt_parm {
 	unsigned int rsvd;
 };
 
-struct getbcnokcnt_rsp{
-	unsigned long  bcnokcnt;
+struct getbcnokcnt_rsp {
+	unsigned long bcnokcnt;
 };
 
-struct getbcnerrcnt_parm{
+struct getbcnerrcnt_parm {
 	unsigned int rsvd;
 };
-struct getbcnerrcnt_rsp{
+struct getbcnerrcnt_rsp {
 	unsigned long bcnerrcnt;
 };
 
 /* to get current TX power level*/
-struct getcurtxpwrlevel_parm{
+struct getcurtxpwrlevel_parm {
 	unsigned int rsvd;
 };
 
-struct getcurtxpwrlevel_rsp{
+struct getcurtxpwrlevel_rsp {
 	unsigned short tx_power;
 };
 
 /*dynamic on/off DIG*/
-struct setdig_parm{
+struct setdig_parm {
 	unsigned char dig_on;	/* 1:on , 0:off */
 };
 
 /*dynamic on/off RA*/
-struct setra_parm{
+struct setra_parm {
 	unsigned char ra_on;	/* 1:on , 0:off */
 };
 
diff --git a/drivers/staging/rtl8712/rtl871x_event.h b/drivers/staging/rtl8712/rtl871x_event.h
index d452293..6ce0676 100644
--- a/drivers/staging/rtl8712/rtl871x_event.h
+++ b/drivers/staging/rtl8712/rtl871x_event.h
@@ -45,8 +45,8 @@ struct stassoc_event {
 };
 
 struct stadel_event {
- unsigned char macaddr[6];
- unsigned char rsvd[2];
+	unsigned char macaddr[6];
+	unsigned char rsvd[2];
 };
 
 struct addba_event {
@@ -61,7 +61,7 @@ struct fwevent {
 };
 
 #define C2HEVENT_SZ			32
-struct event_node{
+struct event_node {
 	unsigned char *node;
 	unsigned char evt_code;
 	unsigned short evt_sz;
@@ -85,9 +85,9 @@ struct network_queue {
 };
 
 struct ADDBA_Req_Report_parm {
- unsigned char MacAddress[ETH_ALEN];
- unsigned short StartSeqNum;
- unsigned char tid;
+	unsigned char MacAddress[ETH_ALEN];
+	unsigned short StartSeqNum;
+	unsigned char tid;
 };
 #include "rtl8712_event.h"
 
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_set.h b/drivers/staging/rtl8712/rtl871x_ioctl_set.h
index 283afbf..8dff2b1 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_set.h
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_set.h
@@ -6,19 +6,27 @@
 typedef u8 NDIS_802_11_PMKID_VALUE[16];
 
 struct BSSIDInfo {
-	unsigned char  BSSID[6];
-	NDIS_802_11_PMKID_VALUE  PMKID;
+	unsigned char BSSID[6];
+	NDIS_802_11_PMKID_VALUE PMKID;
 };
 
 u8 r8712_set_802_11_authentication_mode(struct _adapter *pdapter,
 			enum NDIS_802_11_AUTHENTICATION_MODE authmode);
+
 u8 r8712_set_802_11_bssid(struct _adapter *padapter, u8 *bssid);
-u8 r8712_set_802_11_add_wep(struct _adapter *padapter, struct NDIS_802_11_WEP *wep);
+
+u8 r8712_set_802_11_add_wep(struct _adapter *padapter,
+			    struct NDIS_802_11_WEP *wep);
+
 u8 r8712_set_802_11_disassociate(struct _adapter *padapter);
+
 u8 r8712_set_802_11_bssid_list_scan(struct _adapter *padapter);
+
 u8 r8712_set_802_11_infrastructure_mode(struct _adapter *padapter,
 			enum NDIS_802_11_NETWORK_INFRASTRUCTURE networktype);
-void r8712_set_802_11_ssid(struct _adapter *padapter, struct ndis_802_11_ssid *ssid);
+
+void r8712_set_802_11_ssid(struct _adapter *padapter,
+			   struct ndis_802_11_ssid *ssid);
 
 #endif
 
diff --git a/drivers/staging/rtl8712/rtl871x_mp_ioctl.h b/drivers/staging/rtl8712/rtl871x_mp_ioctl.h
index fdd2278..67759c3 100644
--- a/drivers/staging/rtl8712/rtl871x_mp_ioctl.h
+++ b/drivers/staging/rtl8712/rtl871x_mp_ioctl.h
@@ -281,23 +281,23 @@ enum MP_MODE {
 	MP_ERR_MODE
 };
 
-struct rwreg_param{
+struct rwreg_param {
 	unsigned int offset;
 	unsigned int width;
 	unsigned int value;
 };
 
-struct bbreg_param{
+struct bbreg_param {
 	unsigned int offset;
 	unsigned int phymask;
 	unsigned int value;
 };
 
-struct txpower_param{
+struct txpower_param {
 	unsigned int pwr_index;
 };
 
-struct datarate_param{
+struct datarate_param {
 	unsigned int rate_index;
 };
 
@@ -321,7 +321,7 @@ struct mp_ioctl_handler {
 	unsigned int oid;
 };
 
-struct mp_ioctl_param{
+struct mp_ioctl_param {
 	unsigned int subcode;
 	unsigned int len;
 	unsigned char data[0];
diff --git a/drivers/staging/rtl8712/rtl871x_recv.h b/drivers/staging/rtl8712/rtl871x_recv.h
index bf8115d..cc7a72f 100644
--- a/drivers/staging/rtl8712/rtl871x_recv.h
+++ b/drivers/staging/rtl8712/rtl871x_recv.h
@@ -19,9 +19,9 @@
 /* for Rx reordering buffer control */
 struct recv_reorder_ctrl {
 	struct _adapter	*padapter;
-	u16 indicate_seq;/* =wstart_b, init_value=0xffff */
+	u16 indicate_seq; /* =wstart_b, init_value=0xffff */
 	u16 wend_b;
-       u8 wsize_b;
+	u8 wsize_b;
 	struct  __queue pending_recvframe_queue;
 	struct timer_list reordering_ctrl_timer;
 };
diff --git a/drivers/staging/rtl8712/rtl871x_rf.h b/drivers/staging/rtl8712/rtl871x_rf.h
index c709d8c..6c54966 100644
--- a/drivers/staging/rtl8712/rtl871x_rf.h
+++ b/drivers/staging/rtl8712/rtl871x_rf.h
@@ -22,7 +22,7 @@ struct	regulatory_class {
 	u8	modem;
 };
 
-enum	_REG_PREAMBLE_MODE{
+enum	_REG_PREAMBLE_MODE {
 	PREAMBLE_LONG	= 1,
 	PREAMBLE_AUTO	= 2,
 	PREAMBLE_SHORT	= 3,
diff --git a/drivers/staging/rtl8712/rtl871x_security.h b/drivers/staging/rtl8712/rtl871x_security.h
index 782b70a..bff71d2 100644
--- a/drivers/staging/rtl8712/rtl871x_security.h
+++ b/drivers/staging/rtl8712/rtl871x_security.h
@@ -21,30 +21,31 @@
 #ifndef Ndis802_11AuthModeWPA2PSK
 #define Ndis802_11AuthModeWPA2PSK (Ndis802_11AuthModeWPANone + 2)
 #endif
+
 union pn48 {
 	u64 val;
 #if defined(__BIG_ENDIAN)
-struct {
-  u8 TSC7;
-  u8 TSC6;
-  u8 TSC5;
-  u8 TSC4;
-  u8 TSC3;
-  u8 TSC2;
-  u8 TSC1;
-  u8 TSC0;
-} _byte_;
+	struct {
+		u8 TSC7;
+		u8 TSC6;
+		u8 TSC5;
+		u8 TSC4;
+		u8 TSC3;
+		u8 TSC2;
+		u8 TSC1;
+		u8 TSC0;
+	} _byte_;
 #else
-struct {
-  u8 TSC0;
-  u8 TSC1;
-  u8 TSC2;
-  u8 TSC3;
-  u8 TSC4;
-  u8 TSC5;
-  u8 TSC6;
-  u8 TSC7;
-} _byte_;
+	struct {
+		u8 TSC0;
+		u8 TSC1;
+		u8 TSC2;
+		u8 TSC3;
+		u8 TSC4;
+		u8 TSC5;
+		u8 TSC6;
+		u8 TSC7;
+	} _byte_;
 #endif
 };
 
@@ -174,11 +175,11 @@ struct mic_data {
 };
 
 void seccalctkipmic(
-	u8 *key,
-	u8 *header,
-	u8 *data,
-	u32 data_len,
-	u8 *Miccode,
+	u8  *key,
+	u8  *header,
+	u8  *data,
+	u32  data_len,
+	u8  *Miccode,
 	u8   priority);
 
 void r8712_secmicsetkey(struct mic_data *pmicdata, u8 * key);
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.h b/drivers/staging/rtl8712/rtl871x_xmit.h
index d518ce8..df13e67 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.h
+++ b/drivers/staging/rtl8712/rtl871x_xmit.h
@@ -244,7 +244,8 @@ sint r8712_update_attrib(struct _adapter *padapter, _pkt *pkt,
 			 struct pkt_attrib *pattrib);
 int r8712_txframes_sta_ac_pending(struct _adapter *padapter,
 				  struct pkt_attrib *pattrib);
-sint _r8712_init_xmit_priv(struct xmit_priv *pxmitpriv, struct _adapter *padapter);
+sint _r8712_init_xmit_priv(struct xmit_priv *pxmitpriv,
+			   struct _adapter *padapter);
 void _free_xmit_priv(struct xmit_priv *pxmitpriv);
 void r8712_free_xmitframe_ex(struct xmit_priv *pxmitpriv,
 			     struct xmit_frame *pxmitframe);
diff --git a/drivers/staging/rtl8712/wifi.h b/drivers/staging/rtl8712/wifi.h
index 86d4b98..6032cdc 100644
--- a/drivers/staging/rtl8712/wifi.h
+++ b/drivers/staging/rtl8712/wifi.h
@@ -39,38 +39,35 @@ enum WIFI_FRAME_TYPE {
 };
 
 enum WIFI_FRAME_SUBTYPE {
-
-    /* below is for mgt frame */
-    WIFI_ASSOCREQ       = (0 | WIFI_MGT_TYPE),
-    WIFI_ASSOCRSP       = (BIT(4) | WIFI_MGT_TYPE),
-    WIFI_REASSOCREQ     = (BIT(5) | WIFI_MGT_TYPE),
-    WIFI_REASSOCRSP     = (BIT(5) | BIT(4) | WIFI_MGT_TYPE),
-    WIFI_PROBEREQ       = (BIT(6) | WIFI_MGT_TYPE),
-    WIFI_PROBERSP       = (BIT(6) | BIT(4) | WIFI_MGT_TYPE),
-    WIFI_BEACON         = (BIT(7) | WIFI_MGT_TYPE),
-    WIFI_ATIM           = (BIT(7) | BIT(4) | WIFI_MGT_TYPE),
-    WIFI_DISASSOC       = (BIT(7) | BIT(5) | WIFI_MGT_TYPE),
-    WIFI_AUTH           = (BIT(7) | BIT(5) | BIT(4) | WIFI_MGT_TYPE),
-    WIFI_DEAUTH         = (BIT(7) | BIT(6) | WIFI_MGT_TYPE),
-    WIFI_ACTION         = (BIT(7) | BIT(6) | BIT(4) | WIFI_MGT_TYPE),
-
-    /* below is for control frame */
-    WIFI_PSPOLL         = (BIT(7) | BIT(5) | WIFI_CTRL_TYPE),
-    WIFI_RTS            = (BIT(7) | BIT(5) | BIT(4) | WIFI_CTRL_TYPE),
-    WIFI_CTS            = (BIT(7) | BIT(6) | WIFI_CTRL_TYPE),
-    WIFI_ACK            = (BIT(7) | BIT(6) | BIT(4) | WIFI_CTRL_TYPE),
-    WIFI_CFEND          = (BIT(7) | BIT(6) | BIT(5) | WIFI_CTRL_TYPE),
-    WIFI_CFEND_CFACK    = (BIT(7) | BIT(6) | BIT(5) | BIT(4) | WIFI_CTRL_TYPE),
-
-    /* below is for data frame */
-    WIFI_DATA           = (0 | WIFI_DATA_TYPE),
-    WIFI_DATA_CFACK     = (BIT(4) | WIFI_DATA_TYPE),
-    WIFI_DATA_CFPOLL    = (BIT(5) | WIFI_DATA_TYPE),
-    WIFI_DATA_CFACKPOLL = (BIT(5) | BIT(4) | WIFI_DATA_TYPE),
-    WIFI_DATA_NULL      = (BIT(6) | WIFI_DATA_TYPE),
-    WIFI_CF_ACK         = (BIT(6) | BIT(4) | WIFI_DATA_TYPE),
-    WIFI_CF_POLL        = (BIT(6) | BIT(5) | WIFI_DATA_TYPE),
-    WIFI_CF_ACKPOLL     = (BIT(6) | BIT(5) | BIT(4) | WIFI_DATA_TYPE),
+	/* below is for mgt frame */
+	WIFI_ASSOCREQ       = (0 | WIFI_MGT_TYPE),
+	WIFI_ASSOCRSP       = (BIT(4) | WIFI_MGT_TYPE),
+	WIFI_REASSOCREQ     = (BIT(5) | WIFI_MGT_TYPE),
+	WIFI_REASSOCRSP     = (BIT(5) | BIT(4) | WIFI_MGT_TYPE),
+	WIFI_PROBEREQ       = (BIT(6) | WIFI_MGT_TYPE),
+	WIFI_PROBERSP       = (BIT(6) | BIT(4) | WIFI_MGT_TYPE),
+	WIFI_BEACON         = (BIT(7) | WIFI_MGT_TYPE),
+	WIFI_ATIM           = (BIT(7) | BIT(4) | WIFI_MGT_TYPE),
+	WIFI_DISASSOC       = (BIT(7) | BIT(5) | WIFI_MGT_TYPE),
+	WIFI_AUTH           = (BIT(7) | BIT(5) | BIT(4) | WIFI_MGT_TYPE),
+	WIFI_DEAUTH         = (BIT(7) | BIT(6) | WIFI_MGT_TYPE),
+	WIFI_ACTION         = (BIT(7) | BIT(6) | BIT(4) | WIFI_MGT_TYPE),
+	/* below is for control frame */
+	WIFI_PSPOLL         = (BIT(7) | BIT(5) | WIFI_CTRL_TYPE),
+	WIFI_RTS            = (BIT(7) | BIT(5) | BIT(4) | WIFI_CTRL_TYPE),
+	WIFI_CTS            = (BIT(7) | BIT(6) | WIFI_CTRL_TYPE),
+	WIFI_ACK            = (BIT(7) | BIT(6) | BIT(4) | WIFI_CTRL_TYPE),
+	WIFI_CFEND          = (BIT(7) | BIT(6) | BIT(5) | WIFI_CTRL_TYPE),
+	WIFI_CFEND_CFACK = (BIT(7) | BIT(6) | BIT(5) | BIT(4) | WIFI_CTRL_TYPE),
+	/* below is for data frame */
+	WIFI_DATA           = (0 | WIFI_DATA_TYPE),
+	WIFI_DATA_CFACK     = (BIT(4) | WIFI_DATA_TYPE),
+	WIFI_DATA_CFPOLL    = (BIT(5) | WIFI_DATA_TYPE),
+	WIFI_DATA_CFACKPOLL = (BIT(5) | BIT(4) | WIFI_DATA_TYPE),
+	WIFI_DATA_NULL      = (BIT(6) | WIFI_DATA_TYPE),
+	WIFI_CF_ACK         = (BIT(6) | BIT(4) | WIFI_DATA_TYPE),
+	WIFI_CF_POLL        = (BIT(6) | BIT(5) | WIFI_DATA_TYPE),
+	WIFI_CF_ACKPOLL     = (BIT(6) | BIT(5) | BIT(4) | WIFI_DATA_TYPE),
 };
 
 enum WIFI_REASON_CODE	{
@@ -84,7 +81,6 @@ enum WIFI_REASON_CODE	{
 	_RSON_CLS3_			= 7,
 	_RSON_DISAOC_STA_LEAVING_	= 8,
 	_RSON_ASOC_NOT_AUTH_		= 9,
-
 	/* WPA reason */
 	_RSON_INVALID_IE_		= 13,
 	_RSON_MIC_FAILURE_		= 14,
@@ -97,7 +93,6 @@ enum WIFI_REASON_CODE	{
 	_RSON_UNSUPPORT_RSNE_VER_	= 21,
 	_RSON_INVALID_RSNE_CAP_		= 22,
 	_RSON_IEEE_802DOT1X_AUTH_FAIL_	= 23,
-
 	/* below are Realtek definitions */
 	_RSON_PMK_NOT_AVAILABLE_	= 24,
 };
diff --git a/drivers/staging/rtl8712/wlan_bssdef.h b/drivers/staging/rtl8712/wlan_bssdef.h
index 6d92952..0d90e1f 100644
--- a/drivers/staging/rtl8712/wlan_bssdef.h
+++ b/drivers/staging/rtl8712/wlan_bssdef.h
@@ -13,23 +13,23 @@ typedef unsigned char   NDIS_802_11_RATES[NDIS_802_11_LENGTH_RATES];
 typedef unsigned char   NDIS_802_11_RATES_EX[NDIS_802_11_LENGTH_RATES_EX];
 
 struct ndis_802_11_ssid {
-  u32  SsidLength;
-  u8  Ssid[32];
+	u32 SsidLength;
+	u8  Ssid[32];
 };
 
 enum NDIS_802_11_NETWORK_TYPE {
-    Ndis802_11FH,
-    Ndis802_11DS,
-    Ndis802_11OFDM5,
-    Ndis802_11OFDM24,
-    Ndis802_11NetworkTypeMax    /* not a real type, defined as an upper bound */
+	Ndis802_11FH,
+	Ndis802_11DS,
+	Ndis802_11OFDM5,
+	Ndis802_11OFDM24,
+	Ndis802_11NetworkTypeMax /* not a real type, defined as an upper bound*/
 };
 
 struct NDIS_802_11_CONFIGURATION_FH {
-    u32           Length;             /* Length of structure */
-    u32           HopPattern;         /* As defined by 802.11, MSB set */
-    u32           HopSet;             /* to one if non-802.11 */
-    u32           DwellTime;          /* units are Kusec */
+	u32 Length;             /* Length of structure */
+	u32 HopPattern;         /* As defined by 802.11, MSB set */
+	u32 HopSet;             /* to one if non-802.11 */
+	u32 DwellTime;          /* units are Kusec */
 };
 
 /*
@@ -37,25 +37,25 @@ struct NDIS_802_11_CONFIGURATION_FH {
 	ODI Handler will convert the channel number to freq. number.
 */
 struct NDIS_802_11_CONFIGURATION {
-    u32           Length;             /* Length of structure */
-    u32           BeaconPeriod;       /* units are Kusec */
-    u32           ATIMWindow;         /* units are Kusec */
-    u32           DSConfig;           /* Frequency, units are kHz */
-    struct NDIS_802_11_CONFIGURATION_FH    FHConfig;
+	u32 Length;             /* Length of structure */
+	u32 BeaconPeriod;       /* units are Kusec */
+	u32 ATIMWindow;         /* units are Kusec */
+	u32 DSConfig;           /* Frequency, units are kHz */
+	struct NDIS_802_11_CONFIGURATION_FH FHConfig;
 };
 
 enum NDIS_802_11_NETWORK_INFRASTRUCTURE {
-    Ndis802_11IBSS,
-    Ndis802_11Infrastructure,
-    Ndis802_11AutoUnknown,
-    Ndis802_11InfrastructureMax, /* Not a real value, defined as upper bound */
-    Ndis802_11APMode
+	Ndis802_11IBSS,
+	Ndis802_11Infrastructure,
+	Ndis802_11AutoUnknown,
+	Ndis802_11InfrastructureMax, /*Not a real value,defined as upper bound*/
+	Ndis802_11APMode
 };
 
 struct NDIS_802_11_FIXED_IEs {
-  u8  Timestamp[8];
-  u16  BeaconInterval;
-  u16  Capabilities;
+	u8  Timestamp[8];
+	u16 BeaconInterval;
+	u16 Capabilities;
 };
 
 /*
@@ -70,44 +70,44 @@ struct NDIS_802_11_FIXED_IEs {
  */
 
 struct ndis_wlan_bssid_ex {
-  u32  Length;
-  unsigned char  MacAddress[6];
-  u8  Reserved[2];
-  struct ndis_802_11_ssid  Ssid;
-  u32  Privacy;
-  s32  Rssi;
-  enum NDIS_802_11_NETWORK_TYPE  NetworkTypeInUse;
-  struct NDIS_802_11_CONFIGURATION  Configuration;
-  enum NDIS_802_11_NETWORK_INFRASTRUCTURE  InfrastructureMode;
-  NDIS_802_11_RATES_EX  SupportedRates;
-  u32  IELength;
-/*(timestamp, beacon interval, and capability information) */
-  u8  IEs[MAX_IE_SZ];
+	u32 Length;
+	unsigned char  MacAddress[6];
+	u8  Reserved[2];
+	struct ndis_802_11_ssid  Ssid;
+	u32 Privacy;
+	s32 Rssi;
+	enum NDIS_802_11_NETWORK_TYPE  NetworkTypeInUse;
+	struct NDIS_802_11_CONFIGURATION  Configuration;
+	enum NDIS_802_11_NETWORK_INFRASTRUCTURE  InfrastructureMode;
+	NDIS_802_11_RATES_EX  SupportedRates;
+	u32 IELength;
+	/*(timestamp, beacon interval, and capability information) */
+	u8 IEs[MAX_IE_SZ];
 };
 
 enum NDIS_802_11_AUTHENTICATION_MODE {
-    Ndis802_11AuthModeOpen,
-    Ndis802_11AuthModeShared,
-    Ndis802_11AuthModeAutoSwitch,
-    Ndis802_11AuthModeWPA,
-    Ndis802_11AuthModeWPAPSK,
-    Ndis802_11AuthModeWPANone,
-    Ndis802_11AuthModeMax     /* Not a real mode, defined as upper bound */
+	Ndis802_11AuthModeOpen,
+	Ndis802_11AuthModeShared,
+	Ndis802_11AuthModeAutoSwitch,
+	Ndis802_11AuthModeWPA,
+	Ndis802_11AuthModeWPAPSK,
+	Ndis802_11AuthModeWPANone,
+	Ndis802_11AuthModeMax      /* Not a real mode, defined as upper bound */
 };
 
 enum {
-    Ndis802_11WEPEnabled,
-    Ndis802_11Encryption1Enabled = Ndis802_11WEPEnabled,
-    Ndis802_11WEPDisabled,
-    Ndis802_11EncryptionDisabled = Ndis802_11WEPDisabled,
-    Ndis802_11WEPKeyAbsent,
-    Ndis802_11Encryption1KeyAbsent = Ndis802_11WEPKeyAbsent,
-    Ndis802_11WEPNotSupported,
-    Ndis802_11EncryptionNotSupported = Ndis802_11WEPNotSupported,
-    Ndis802_11Encryption2Enabled,
-    Ndis802_11Encryption2KeyAbsent,
-    Ndis802_11Encryption3Enabled,
-    Ndis802_11Encryption3KeyAbsent
+	Ndis802_11WEPEnabled,
+	Ndis802_11Encryption1Enabled = Ndis802_11WEPEnabled,
+	Ndis802_11WEPDisabled,
+	Ndis802_11EncryptionDisabled = Ndis802_11WEPDisabled,
+	Ndis802_11WEPKeyAbsent,
+	Ndis802_11Encryption1KeyAbsent = Ndis802_11WEPKeyAbsent,
+	Ndis802_11WEPNotSupported,
+	Ndis802_11EncryptionNotSupported = Ndis802_11WEPNotSupported,
+	Ndis802_11Encryption2Enabled,
+	Ndis802_11Encryption2KeyAbsent,
+	Ndis802_11Encryption3Enabled,
+	Ndis802_11Encryption3KeyAbsent
 };
 
 #define NDIS_802_11_AI_REQFI_CAPABILITIES      1
@@ -119,51 +119,51 @@ enum {
 #define NDIS_802_11_AI_RESFI_ASSOCIATIONID     4
 
 struct NDIS_802_11_AI_REQFI {
-    u16 Capabilities;
-    u16 ListenInterval;
-    unsigned char CurrentAPAddress[6];
+	u16 Capabilities;
+	u16 ListenInterval;
+	unsigned char CurrentAPAddress[6];
 };
 
 struct NDIS_802_11_AI_RESFI {
-    u16 Capabilities;
-    u16 StatusCode;
-    u16 AssociationId;
+	u16 Capabilities;
+	u16 StatusCode;
+	u16 AssociationId;
 };
 
 struct NDIS_802_11_ASSOCIATION_INFORMATION {
-    u32                   Length;
-    u16                  AvailableRequestFixedIEs;
-    struct NDIS_802_11_AI_REQFI    RequestFixedIEs;
-    u32                   RequestIELength;
-    u32                   OffsetRequestIEs;
-    u16                  AvailableResponseFixedIEs;
-    struct NDIS_802_11_AI_RESFI    ResponseFixedIEs;
-    u32                   ResponseIELength;
-    u32                   OffsetResponseIEs;
+	u32 Length;
+	u16 AvailableRequestFixedIEs;
+	struct NDIS_802_11_AI_REQFI RequestFixedIEs;
+	u32 RequestIELength;
+	u32 OffsetRequestIEs;
+	u16 AvailableResponseFixedIEs;
+	struct NDIS_802_11_AI_RESFI ResponseFixedIEs;
+	u32 ResponseIELength;
+	u32 OffsetResponseIEs;
 };
 
 /* Key mapping keys require a BSSID*/
 struct NDIS_802_11_KEY {
-    u32           Length;             /* Length of this structure */
-    u32           KeyIndex;
-    u32           KeyLength;          /* length of key in bytes */
-    unsigned char BSSID[6];
-    unsigned long long KeyRSC;
-    u8           KeyMaterial[32];     /* variable length */
+	u32 Length;			/* Length of this structure */
+	u32 KeyIndex;
+	u32 KeyLength;			/* length of key in bytes */
+	unsigned char BSSID[6];
+	unsigned long long KeyRSC;
+	u8  KeyMaterial[32];		/* variable length */
 };
 
 struct NDIS_802_11_REMOVE_KEY {
-    u32                   Length;        /* Length of this structure */
-    u32                   KeyIndex;
-    unsigned char BSSID[6];
+	u32 Length;			/* Length of this structure */
+	u32 KeyIndex;
+	unsigned char BSSID[6];
 };
 
 struct NDIS_802_11_WEP {
-    u32     Length;        /* Length of this structure */
-    u32     KeyIndex;      /* 0 is the per-client key,
-			      * 1-N are the global keys */
-    u32     KeyLength;     /* length of key in bytes */
-    u8     KeyMaterial[16];/* variable length depending on above field */
+	u32 Length;		  /* Length of this structure */
+	u32 KeyIndex;		  /* 0 is the per-client key,
+				   * 1-N are the global keys */
+	u32 KeyLength;		  /* length of key in bytes */
+	u8  KeyMaterial[16];      /* variable length depending on above field */
 };
 
 /* mask for authentication/integrity fields */
@@ -192,15 +192,15 @@ struct	wlan_network {
 };
 
 enum VRTL_CARRIER_SENSE {
-    DISABLE_VCS,
-    ENABLE_VCS,
-    AUTO_VCS
+	DISABLE_VCS,
+	ENABLE_VCS,
+	AUTO_VCS
 };
 
 enum VCS_TYPE {
-    NONE_VCS,
-    RTS_CTS,
-    CTS_TO_SELF
+	NONE_VCS,
+	RTS_CTS,
+	CTS_TO_SELF
 };
 
 #define PWR_CAM 0
@@ -211,9 +211,9 @@ enum VCS_TYPE {
 
 enum UAPSD_MAX_SP {
 	NO_LIMIT,
-       TWO_MSDU,
-       FOUR_MSDU,
-       SIX_MSDU
+	TWO_MSDU,
+	FOUR_MSDU,
+	SIX_MSDU
 };
 
 #define NUM_PRE_AUTH_KEY 16
@@ -223,18 +223,18 @@ enum UAPSD_MAX_SP {
  *	WPA2
  */
 struct wlan_bssid_ex {
-  u32  Length;
-  unsigned char  MacAddress[6];
-  u8  Reserved[2];
-  struct ndis_802_11_ssid  Ssid;
-  u32  Privacy;
-  s32  Rssi;
-  enum NDIS_802_11_NETWORK_TYPE  NetworkTypeInUse;
-  struct NDIS_802_11_CONFIGURATION  Configuration;
-  enum NDIS_802_11_NETWORK_INFRASTRUCTURE  InfrastructureMode;
-  NDIS_802_11_RATES_EX  SupportedRates;
-  u32  IELength;
-  u8  IEs[MAX_IE_SZ];	/* (timestamp, beacon interval, and capability
+	u32 Length;
+	unsigned char  MacAddress[6];
+	u8  Reserved[2];
+	struct ndis_802_11_ssid  Ssid;
+	u32 Privacy;
+	s32 Rssi;
+	enum NDIS_802_11_NETWORK_TYPE  NetworkTypeInUse;
+	struct NDIS_802_11_CONFIGURATION  Configuration;
+	enum NDIS_802_11_NETWORK_INFRASTRUCTURE  InfrastructureMode;
+	NDIS_802_11_RATES_EX  SupportedRates;
+	u32 IELength;
+	u8  IEs[MAX_IE_SZ];	/* (timestamp, beacon interval, and capability
 				 * information) */
 };
 
-- 
1.7.4.1

