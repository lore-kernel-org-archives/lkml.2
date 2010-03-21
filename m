Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab0CUQy7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 12:54:59 -0400
Received: from smtprelay-h12.telenor.se ([62.127.194.5]:50387 "EHLO
	smtprelay-h12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab0CUQy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 12:54:57 -0400
X-SENDER-IP: [83.226.249.129]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Amk2AAbspUtT4vmBPGdsb2JhbACbOgwBAQEBNy2rUIxZhH0E
X-IronPort-AV: E=Sophos;i="4.51,283,1267398000"; 
   d="scan'208";a="53857162"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: sme_api.h Coding style fixes.
Date: Sun, 21 Mar 2010 17:55:03 +0100
Message-Id: <1269190503-12050-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed the things reported by checkpatch.pl except
one long line and a __inline.
I also removed commented away code and versioning comments.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/winbond/sme_api.h |  211 +++++++++++++------------------------
 1 files changed, 71 insertions(+), 140 deletions(-)

diff --git a/drivers/staging/winbond/sme_api.h b/drivers/staging/winbond/sme_api.h
index b589829..8f4596c 100644
--- a/drivers/staging/winbond/sme_api.h
+++ b/drivers/staging/winbond/sme_api.h
@@ -2,12 +2,6 @@
  * sme_api.h
  *
  * Copyright(C) 2002 Winbond Electronics Corp.
- *
- * modification history
- * ---------------------------------------------------------------------------
- * 1.00.001, 2003-04-21, Kevin       created
- * 1.00.002, 2003-05-14, PD43 & PE20 modified
- *
  */
 
 #ifndef __SME_API_H__
@@ -18,42 +12,42 @@
 #include "localpara.h"
 
 /****************** CONSTANT AND MACRO SECTION ******************************/
-#define _INLINE      __inline
+#define _INLINE				__inline
 
-#define MEDIA_STATE_DISCONNECTED    0
-#define MEDIA_STATE_CONNECTED       1
+#define MEDIA_STATE_DISCONNECTED	0
+#define MEDIA_STATE_CONNECTED		1
 
-//ARRAY CHECK
-#define MAX_POWER_TO_DB 32
+/* ARRAY CHECK */
+#define MAX_POWER_TO_DB			32
 
 /****************** TYPE DEFINITION SECTION *********************************/
 
 /****************** EXPORTED FUNCTION DECLARATION SECTION *******************/
 
-// OID_802_11_BSSID
+/* OID_802_11_BSSID */
 s8 sme_get_bssid(void *pcore_data, u8 *pbssid);
-s8 sme_get_desired_bssid(void *pcore_data, u8 *pbssid);//Not use
+s8 sme_get_desired_bssid(void *pcore_data, u8 *pbssid); /* Not use */
 s8 sme_set_desired_bssid(void *pcore_data, u8 *pbssid);
 
-// OID_802_11_SSID
+/* OID_802_11_SSID */
 s8 sme_get_ssid(void *pcore_data, u8 *pssid, u8 *pssid_len);
-s8 sme_get_desired_ssid(void *pcore_data, u8 *pssid, u8 *pssid_len);// Not use
+s8 sme_get_desired_ssid(void *pcore_data, u8 *pssid, u8 *pssid_len);/* Not use */
 s8 sme_set_desired_ssid(void *pcore_data, u8 *pssid, u8 ssid_len);
 
-// OID_802_11_INFRASTRUCTURE_MODE
+/* OID_802_11_INFRASTRUCTURE_MODE */
 s8 sme_get_bss_type(void *pcore_data, u8 *pbss_type);
-s8 sme_get_desired_bss_type(void *pcore_data, u8 *pbss_type);//Not use
+s8 sme_get_desired_bss_type(void *pcore_data, u8 *pbss_type); /* Not use */
 s8 sme_set_desired_bss_type(void *pcore_data, u8 bss_type);
 
-// OID_802_11_FRAGMENTATION_THRESHOLD
+/* OID_802_11_FRAGMENTATION_THRESHOLD */
 s8 sme_get_fragment_threshold(void *pcore_data, u32 *pthreshold);
 s8 sme_set_fragment_threshold(void *pcore_data, u32 threshold);
 
-// OID_802_11_RTS_THRESHOLD
+/* OID_802_11_RTS_THRESHOLD */
 s8 sme_get_rts_threshold(void *pcore_data, u32 *pthreshold);
 s8 sme_set_rts_threshold(void *pcore_data, u32 threshold);
 
-// OID_802_11_CONFIGURATION
+/* OID_802_11_CONFIGURATION */
 s8 sme_get_beacon_period(void *pcore_data, u16 *pbeacon_period);
 s8 sme_set_beacon_period(void *pcore_data, u16 beacon_period);
 
@@ -64,116 +58,69 @@ s8 sme_get_current_channel(void *pcore_data, u8 *pcurrent_channel);
 s8 sme_get_current_band(void *pcore_data, u8 *pcurrent_band);
 s8 sme_set_current_channel(void *pcore_data, u8 current_channel);
 
-// OID_802_11_BSSID_LIST
+/* OID_802_11_BSSID_LIST */
 s8 sme_get_scan_bss_count(void *pcore_data, u8 *pcount);
 s8 sme_get_scan_bss(void *pcore_data, u8 index, void **ppbss);
 
 s8 sme_get_connected_bss(void *pcore_data, void **ppbss_now);
 
-// OID_802_11_AUTHENTICATION_MODE
+/* OID_802_11_AUTHENTICATION_MODE */
 s8 sme_get_auth_mode(void *pcore_data, u8 *pauth_mode);
 s8 sme_set_auth_mode(void *pcore_data, u8 auth_mode);
 
-// OID_802_11_WEP_STATUS / OID_802_11_ENCRYPTION_STATUS
+/* OID_802_11_WEP_STATUS / OID_802_11_ENCRYPTION_STATUS */
 s8 sme_get_wep_mode(void *pcore_data, u8 *pwep_mode);
 s8 sme_set_wep_mode(void *pcore_data, u8 wep_mode);
-//s8 sme_get_encryption_status(void *pcore_data, u8 *pstatus);
-//s8 sme_set_encryption_status(void *pcore_data, u8 status);
-
-// ???????????????????????????????????????
 
-// OID_GEN_VENDOR_ID
-// OID_802_3_PERMANENT_ADDRESS
+/* OID_GEN_VENDOR_ID */
+/* OID_802_3_PERMANENT_ADDRESS */
 s8 sme_get_permanent_mac_addr(void *pcore_data, u8 *pmac_addr);
 
-// OID_802_3_CURRENT_ADDRESS
+/* OID_802_3_CURRENT_ADDRESS */
 s8 sme_get_current_mac_addr(void *pcore_data, u8 *pmac_addr);
 
-// OID_802_11_NETWORK_TYPE_IN_USE
+/* OID_802_11_NETWORK_TYPE_IN_USE */
 s8 sme_get_network_type_in_use(void *pcore_data, u8 *ptype);
 s8 sme_set_network_type_in_use(void *pcore_data, u8 type);
 
-// OID_802_11_SUPPORTED_RATES
+/* OID_802_11_SUPPORTED_RATES */
 s8 sme_get_supported_rate(void *pcore_data, u8 *prates);
 
-// OID_802_11_ADD_WEP
-//12/29/03' wkchen
+/* OID_802_11_ADD_WEP */
 s8 sme_set_add_wep(void *pcore_data, u32 key_index, u32 key_len,
 					 u8 *Address, u8 *key);
 
-// OID_802_11_REMOVE_WEP
+/* OID_802_11_REMOVE_WEP */
 s8 sme_set_remove_wep(void *pcre_data, u32 key_index);
 
-// OID_802_11_DISASSOCIATE
+/* OID_802_11_DISASSOCIATE */
 s8 sme_set_disassociate(void *pcore_data);
 
-// OID_802_11_POWER_MODE
+/* OID_802_11_POWER_MODE */
 s8 sme_get_power_mode(void *pcore_data, u8 *pmode);
 s8 sme_set_power_mode(void *pcore_data, u8 mode);
 
-// OID_802_11_BSSID_LIST_SCAN
+/* OID_802_11_BSSID_LIST_SCAN */
 s8 sme_set_bssid_list_scan(void *pcore_data, void *pscan_para);
 
-// OID_802_11_RELOAD_DEFAULTS
+/* OID_802_11_RELOAD_DEFAULTS */
 s8 sme_set_reload_defaults(void *pcore_data, u8 reload_type);
 
 
-// The following SME API functions are used for WPA
-//
-// Mandatory OIDs for WPA
-//
-
-// OID_802_11_ADD_KEY
-//s8 sme_set_add_key(void *pcore_data, NDIS_802_11_KEY *pkey);
-
-// OID_802_11_REMOVE_KEY
-//s8 sme_set_remove_key(void *pcore_data, NDIS_802_11_REMOVE_KEY *pkey);
-
-// OID_802_11_ASSOCIATION_INFORMATION
-//s8 sme_set_association_information(void *pcore_data,
-//                    NDIS_802_11_ASSOCIATION_INFORMATION *pinfo);
-
-// OID_802_11_TEST
-//s8 sme_set_test(void *pcore_data, NDIS_802_11_TEST *ptest_data);
-
-//--------------------------------------------------------------------------//
-/*
-// The left OIDs
-
-// OID_802_11_NETWORK_TYPES_SUPPORTED
-// OID_802_11_TX_POWER_LEVEL
-// OID_802_11_RSSI_TRIGGER
-// OID_802_11_NUMBER_OF_ANTENNAS
-// OID_802_11_RX_ANTENNA_SELECTED
-// OID_802_11_TX_ANTENNA_SELECTED
-// OID_802_11_STATISTICS
-// OID_802_11_DESIRED_RATES
-// OID_802_11_PRIVACY_FILTER
-
-*/
-
 /*------------------------- none-standard ----------------------------------*/
 s8 sme_get_connect_status(void *pcore_data, u8 *pstatus);
-
-/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-//s8 sme_get_scan_type(void *pcore_data, u8 *pscan_type);
-//s8 sme_set_scan_type(void *pcore_data, u8 scan_type);
-
-//s8 sme_get_scan_channel_list(void *pcore_data, u8 *pscan_type);
-//s8 sme_set_scan_channel_list(void *pcore_data, u8 scan_type);
-
+/*--------------------------------------------------------------------------*/
 
 void sme_get_encryption_status(void *pcore_data, u8 *EncryptStatus);
 void sme_set_encryption_status(void *pcore_data, u8 EncryptStatus);
-s8 sme_add_key(void		*pcore_data,
-					u32		key_index,
-					u8		key_len,
-					u8		key_type,
-					u8		*key_bssid,
-					//u8		*key_rsc,
-					u8		*ptx_tsc,
-					u8		*prx_tsc,
-					u8		*key_material);
+s8 sme_add_key(void	*pcore_data,
+		u32	key_index,
+		u8	key_len,
+		u8	key_type,
+		u8	*key_bssid,
+		u8	*ptx_tsc,
+		u8	*prx_tsc,
+		u8	*key_material);
 void sme_remove_default_key(void *pcore_data, int index);
 void sme_remove_mapping_key(void *pcore_data, u8 *pmac_addr);
 void sme_clear_all_mapping_key(void *pcore_data);
@@ -202,60 +149,44 @@ u8 sme_set_rx_antenna(void *pcore_data, u32 RxAntenna);
 void sme_get_tx_antenna(void *pcore_data, u32 *TxAntenna);
 s8 sme_set_tx_antenna(void *pcore_data, u32 TxAntenna);
 s8 sme_set_IBSS_chan(void *pcore_data, struct chan_info chan);
-
-//20061108 WPS
 s8 sme_set_IE_append(void *pcore_data, u8 *buffer, u16 buf_len);
 
-
-
-
-//================== Local functions ======================
-//#ifdef _HSINCHU
-//void drv_translate_rssi();   // HW RSSI bit -> NDIS RSSI representation
-//void drv_translate_bss_description(); // Local bss desc -> NDIS bss desc
-//void drv_translate_channel(u8 NetworkType, u8 ChannelNumber, u32 *freq); // channel number -> channel /freq.
-//#endif _HSINCHU
-//
-static const u32 PowerDbToMw[] =
-{
-	56,	//mW, MAX - 0,	17.5 dbm
-	40,	//mW, MAX - 1,	16.0 dbm
-	30,	//mW, MAX - 2,	14.8 dbm
-	20,	//mW, MAX - 3,	13.0 dbm
-	15,	//mW, MAX - 4,	11.8 dbm
-	12,	//mW, MAX - 5,	10.6 dbm
-	9,	//mW, MAX - 6,	 9.4 dbm
-	7,	//mW, MAX - 7,	 8.3 dbm
-	5,	//mW, MAX - 8,	 6.4 dbm
-	4,	//mW, MAX - 9,	 5.3 dbm
-	3,	//mW, MAX - 10,  4.0 dbm
-	2,	//mW, MAX - 11,  ? dbm
-	2,	//mW, MAX - 12,  ? dbm
-	2,	//mW, MAX - 13,  ? dbm
-	2,	//mW, MAX - 14,  ? dbm
-	2,	//mW, MAX - 15,  ? dbm
-	2,	//mW, MAX - 16,  ? dbm
-	2,	//mW, MAX - 17,  ? dbm
-	2,	//mW, MAX - 18,  ? dbm
-	1,	//mW, MAX - 19,  ? dbm
-	1,	//mW, MAX - 20,  ? dbm
-	1,	//mW, MAX - 21,  ? dbm
-	1,	//mW, MAX - 22,  ? dbm
-	1,	//mW, MAX - 23,  ? dbm
-	1,	//mW, MAX - 24,  ? dbm
-	1,	//mW, MAX - 25,  ? dbm
-	1,	//mW, MAX - 26,  ? dbm
-	1,	//mW, MAX - 27,  ? dbm
-	1,	//mW, MAX - 28,  ? dbm
-	1,	//mW, MAX - 29,  ? dbm
-	1,	//mW, MAX - 30,  ? dbm
-	1	//mW, MAX - 31,  ? dbm
+/* ================== Local functions ====================== */
+static const u32 PowerDbToMw[] = {
+	56,	/* mW, MAX - 0,	17.5 dbm */
+	40,	/* mW, MAX - 1,	16.0 dbm */
+	30,	/* mW, MAX - 2,	14.8 dbm */
+	20,	/* mW, MAX - 3,	13.0 dbm */
+	15,	/* mW, MAX - 4,	11.8 dbm */
+	12,	/* mW, MAX - 5,	10.6 dbm */
+	9,	/* mW, MAX - 6,	 9.4 dbm */
+	7,	/* mW, MAX - 7,	 8.3 dbm */
+	5,	/* mW, MAX - 8,	 6.4 dbm */
+	4,	/* mW, MAX - 9,	 5.3 dbm */
+	3,	/* mW, MAX - 10,  4.0 dbm */
+	2,	/* mW, MAX - 11,  ? dbm */
+	2,	/* mW, MAX - 12,  ? dbm */
+	2,	/* mW, MAX - 13,  ? dbm */
+	2,	/* mW, MAX - 14,  ? dbm */
+	2,	/* mW, MAX - 15,  ? dbm */
+	2,	/* mW, MAX - 16,  ? dbm */
+	2,	/* mW, MAX - 17,  ? dbm */
+	2,	/* mW, MAX - 18,  ? dbm */
+	1,	/* mW, MAX - 19,  ? dbm */
+	1,	/* mW, MAX - 20,  ? dbm */
+	1,	/* mW, MAX - 21,  ? dbm */
+	1,	/* mW, MAX - 22,  ? dbm */
+	1,	/* mW, MAX - 23,  ? dbm */
+	1,	/* mW, MAX - 24,  ? dbm */
+	1,	/* mW, MAX - 25,  ? dbm */
+	1,	/* mW, MAX - 26,  ? dbm */
+	1,	/* mW, MAX - 27,  ? dbm */
+	1,	/* mW, MAX - 28,  ? dbm */
+	1,	/* mW, MAX - 29,  ? dbm */
+	1,	/* mW, MAX - 30,  ? dbm */
+	1	/* mW, MAX - 31,  ? dbm */
 };
 
-
-
-
-
 #endif /* __SME_API_H__ */
 
 
-- 
1.7.0.2

