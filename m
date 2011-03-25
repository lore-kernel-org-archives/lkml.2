Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab1CYSO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 14:14:29 -0400
Received: from santostefano.inria.fr ([193.51.192.151]:33636 "HELO
	santostefano.inria.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753612Ab1CYSO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 14:14:28 -0400
Subject: [PATCH] Fix a typo: respose => response (See bug #28172)
From: Sylvestre Ledru <sylvestre.ledru@scilab.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sylvestre Ledru <sylvestre.ledru@scilab.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 25 Mar 2011 19:14:25 +0100
Message-ID: <1301076865.16800.19.camel@losinj.inria.fr>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here is a minor commits which fixes a few minor spelling mistakes.

Signed-off-by: Sylvestre Ledru <sylvestre.ledru@scilab.org>
---
 drivers/input/touchscreen/h3600_ts_input.c         |    2 +-
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |    2 +-
 .../staging/rtl8192e/ieee80211/ieee80211_softmac.c |    4 ++--
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    2 +-
 sound/pci/asihpi/hpi6205.c                         |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/input/touchscreen/h3600_ts_input.c b/drivers/input/touchscreen/h3600_ts_input.c
index b4d7f63..efa0688 100644
--- a/drivers/input/touchscreen/h3600_ts_input.c
+++ b/drivers/input/touchscreen/h3600_ts_input.c
@@ -62,7 +62,7 @@ MODULE_LICENSE("GPL");
         Programmer has no control over these numbers.
         TODO there are holes - specifically  1,7,0x0a
 */
-#define VERSION_ID              0       /* Get Version (request/respose) */
+#define VERSION_ID              0       /* Get Version (request/response) */
 #define KEYBD_ID                2       /* Keyboard (event) */
 #define TOUCHS_ID               3       /* Touch Screen (event)*/
 #define EEPROM_READ_ID          4       /* (request/response) */
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
index 771e019..6257bc7 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -1905,7 +1905,7 @@ associate_complete:
 							}
 						}else{
 							ieee->softmac_stats.rx_auth_rs_err++;
-							IEEE80211_DEBUG_MGMT("Authentication respose status code 0x%x",errcode);
+							IEEE80211_DEBUG_MGMT("Authentication response status code 0x%x",errcode);
 							ieee80211_associate_abort(ieee);
 						}
 
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
index f6922d4..62783b7 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
@@ -2113,9 +2113,9 @@ ieee80211_rx_frame_softmac(struct ieee80211_device *ieee, struct sk_buff *skb,
 							}
 						}else{
 							ieee->softmac_stats.rx_auth_rs_err++;
-							IEEE80211_DEBUG_MGMT("Authentication respose status code 0x%x",errcode);
+							IEEE80211_DEBUG_MGMT("Authentication response status code 0x%x",errcode);
 
-							printk("Authentication respose status code 0x%x",errcode);
+							printk("Authentication response status code 0x%x",errcode);
 							ieee80211_associate_abort(ieee);
 						}
 
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index 4992d63..800b314 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -2063,7 +2063,7 @@ ieee80211_rx_frame_softmac(struct ieee80211_device *ieee, struct sk_buff *skb,
 							}
 						}else{
 							ieee->softmac_stats.rx_auth_rs_err++;
-							IEEE80211_DEBUG_MGMT("Authentication respose status code 0x%x",errcode);
+							IEEE80211_DEBUG_MGMT("Authentication response status code 0x%x",errcode);
 							ieee80211_associate_abort(ieee);
 						}
 
diff --git a/sound/pci/asihpi/hpi6205.c b/sound/pci/asihpi/hpi6205.c
index 620525b..89c19e1 100644
--- a/sound/pci/asihpi/hpi6205.c
+++ b/sound/pci/asihpi/hpi6205.c
@@ -772,7 +772,7 @@ static void outstream_host_buffer_allocate(struct hpi_adapter_obj *pao,
 			&phm->u.d.u.buffer.pci_address);
 		/* get the phys addr into msg for single call alloc caller
 		 * needs to do this for split alloc (or use the same message)
-		 * return the phy address for split alloc in the respose too
+		 * return the phy address for split alloc in the response too
 		 */
 		phr->u.d.u.stream_info.auxiliary_data_available =
 			phm->u.d.u.buffer.pci_address;
-- 
1.7.4.1



