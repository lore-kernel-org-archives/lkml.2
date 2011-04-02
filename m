Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab1DBBC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 21:02:27 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:57243 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab1DBBCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 21:02:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAOd0lk1bdWOb/2dsb2JhbACmWcB1hWsEjSE
X-IronPort-AV: E=Sophos;i="4.63,285,1299452400"; 
   d="scan'208";a="825581165"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com
Cc: linux-kernel@vger.kernel.org, "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 2/2] staging: rtl8712: fixed coding style issues
Date: Sat,  2 Apr 2011 03:02:12 +0200
Message-Id: <1301706132-5501-1-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some style and format issues with code.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/rtl8712/rtl8712_led.c         |    2 +-
 drivers/staging/rtl8712/rtl871x_cmd.c         |    4 ++--
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    6 ++++--
 drivers/staging/rtl8712/rtl871x_ioctl_rtl.c   |    2 +-
 drivers/staging/rtl8712/rtl871x_mp.c          |    5 ++++-
 drivers/staging/rtl8712/rtl871x_recv.c        |   16 +++++++++-------
 6 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl8712_led.c b/drivers/staging/rtl8712/rtl8712_led.c
index 5024ee4..cb1751e 100644
--- a/drivers/staging/rtl8712/rtl8712_led.c
+++ b/drivers/staging/rtl8712/rtl8712_led.c
@@ -49,7 +49,7 @@
  * LED object.
  *===========================================================================
  */
-enum _LED_STATE_871x{
+enum _LED_STATE_871x {
 	LED_UNKNOWN = 0,
 	LED_ON = 1,
 	LED_OFF = 2,
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.c b/drivers/staging/rtl8712/rtl871x_cmd.c
index fbb2e4e..d11e6d1 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -478,8 +478,8 @@ u8 r8712_joinbss_cmd(struct _adapter  *padapter, struct wlan_network *pnetwork)
 		 * to avoid some IOT issues, especially for Realtek 8192u
 		 * SoftAP.
 		 */
-		if ((padapter->securitypriv.PrivacyAlgrthm != _WEP40_ ) &&
-		    (padapter->securitypriv.PrivacyAlgrthm != _WEP104_ )) {
+		if ((padapter->securitypriv.PrivacyAlgrthm != _WEP40_) &&
+		    (padapter->securitypriv.PrivacyAlgrthm != _WEP104_)) {
 			/* restructure_ht_ie */
 			r8712_restructure_ht_ie(padapter,
 						&pnetwork->network.IEs[0],
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index bd315c7..fe22d43 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -291,7 +291,8 @@ static inline char *translate_scan(struct _adapter *padapter,
 			memset(buf, 0, MAX_WPA_IE_LEN);
 			n = sprintf(buf, "wpa_ie=");
 			for (i = 0; i < wpa_len; i++) {
-				n += snprintf(buf + n, MAX_WPA_IE_LEN - n, "%02x", wpa_ie[i]);
+				n += snprintf(buf + n, MAX_WPA_IE_LEN - n,
+							"%02x", wpa_ie[i]);
 				if (n >= MAX_WPA_IE_LEN)
 					break;
 			}
@@ -310,7 +311,8 @@ static inline char *translate_scan(struct _adapter *padapter,
 			memset(buf, 0, MAX_WPA_IE_LEN);
 			n = sprintf(buf, "rsn_ie=");
 			for (i = 0; i < rsn_len; i++) {
-				n += snprintf(buf + n, MAX_WPA_IE_LEN - n, "%02x", rsn_ie[i]);
+				n += snprintf(buf + n, MAX_WPA_IE_LEN - n,
+							"%02x", rsn_ie[i]);
 				if (n >= MAX_WPA_IE_LEN)
 					break;
 			}
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_rtl.c b/drivers/staging/rtl8712/rtl871x_ioctl_rtl.c
index 7adbe82..9a33eae 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_rtl.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_rtl.c
@@ -493,7 +493,7 @@ uint oid_rt_pro_rf_read_registry_hdl(struct oid_par_priv *poid_par_priv)
 	return status;
 }
 
-enum _CONNECT_STATE_{
+enum _CONNECT_STATE_ {
 	CHECKINGSTATUS,
 	ASSOCIATED,
 	ADHOCMODE,
diff --git a/drivers/staging/rtl8712/rtl871x_mp.c b/drivers/staging/rtl8712/rtl871x_mp.c
index 427467c..6be8f5d 100644
--- a/drivers/staging/rtl8712/rtl871x_mp.c
+++ b/drivers/staging/rtl8712/rtl871x_mp.c
@@ -217,7 +217,10 @@ static u32 get_bb_reg(struct _adapter *pAdapter, u16 offset, u32 bitmask)
 	return new_value;
 }
 
-static u8 set_bb_reg(struct _adapter *pAdapter, u16 offset, u32 bitmask, u32 value)
+static u8 set_bb_reg(struct _adapter *pAdapter,
+		     u16 offset,
+		     u32 bitmask,
+		     u32 value)
 {
 	u32 org_value, bit_shift, new_value;
 
diff --git a/drivers/staging/rtl8712/rtl871x_recv.c b/drivers/staging/rtl8712/rtl871x_recv.c
index a3165e6..aec83dd 100644
--- a/drivers/staging/rtl8712/rtl871x_recv.c
+++ b/drivers/staging/rtl8712/rtl871x_recv.c
@@ -307,9 +307,9 @@ static sint recv_decache(union recv_frame *precv_frame, u8 bretry,
 	return _SUCCESS;
 }
 
-static sint sta2sta_data_frame(struct _adapter *adapter, union recv_frame *precv_frame,
-			struct sta_info **psta
-)
+static sint sta2sta_data_frame(struct _adapter *adapter,
+			       union recv_frame *precv_frame,
+			       struct sta_info **psta)
 {
 	u8 *ptr = precv_frame->u.hdr.rx_data;
 	sint ret = _SUCCESS;
@@ -373,8 +373,9 @@ static sint sta2sta_data_frame(struct _adapter *adapter, union recv_frame *precv
 	return ret;
 }
 
-static sint ap2sta_data_frame(struct _adapter *adapter, union recv_frame *precv_frame,
-		       struct sta_info **psta)
+static sint ap2sta_data_frame(struct _adapter *adapter,
+			      union recv_frame *precv_frame,
+			      struct sta_info **psta)
 {
 	u8 *ptr = precv_frame->u.hdr.rx_data;
 	struct rx_pkt_attrib *pattrib = &precv_frame->u.hdr.attrib;
@@ -431,8 +432,9 @@ static sint ap2sta_data_frame(struct _adapter *adapter, union recv_frame *precv_
 	return _SUCCESS;
 }
 
-static sint sta2ap_data_frame(struct _adapter *adapter, union recv_frame *precv_frame,
-		       struct sta_info **psta)
+static sint sta2ap_data_frame(struct _adapter *adapter,
+			      union recv_frame *precv_frame,
+			      struct sta_info **psta)
 {
 	struct rx_pkt_attrib *pattrib = &precv_frame->u.hdr.attrib;
 	struct	sta_priv *pstapriv = &adapter->stapriv;
-- 
1.7.4.1

