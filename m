Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab0LBFgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 00:36:03 -0500
Received: from mail.perches.com ([173.55.12.10]:2128 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912Ab0LBFgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 00:36:00 -0500
Subject: [PATCH 2/2 V2] ath: Fix logging message typos
From: Joe Perches <joe@perches.com>
To: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Bob Copeland <me@bobcopeland.com>,
        Jouni Malinen <jmalinen@atheros.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath9k-devel@venema.h4ckr.net
In-Reply-To: <276469c602c402565b49f99521ea19757429e81e.1291266731.git.joe@perches.com>
References: <276469c602c402565b49f99521ea19757429e81e.1291266731.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 21:35:58 -0800
Message-ID: <1291268158.1761.5.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix immunity misspelling.
Standardize strings from multiple modules.
Add spaces between words of concatenated strings.

Signed-off-by: Joe Perches <joe@perches.com>
---

V2: Fix a newly introduced tyop...

 drivers/net/wireless/ath/ath5k/ani.c          |    2 +-
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    4 ++--
 drivers/net/wireless/ath/ath9k/eeprom_4k.c    |    4 ++--
 drivers/net/wireless/ath/ath9k/eeprom_9287.c  |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c   |    2 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c      |    6 +++---
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
index 6b75b22..9c41881 100644
--- a/drivers/net/wireless/ath/ath5k/ani.c
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -74,7 +74,7 @@ ath5k_ani_set_noise_immunity_level(struct ath5k_hw *ah, int level)
 	static const s8 fr[] = { -78, -80 };
 #endif
 	if (level < 0 || level >= ARRAY_SIZE(sz)) {
-		ATH5K_ERR(ah->ah_sc, "noise immuniy level %d out of range",
+		ATH5K_ERR(ah->ah_sc, "noise immunity level %d out of range",
 			  level);
 		return;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index a7705e7..199131e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -720,7 +720,7 @@ static bool ar9285_hw_cl_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 		if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
 				  AR_PHY_AGC_CONTROL_CAL, 0, AH_WAIT_TIMEOUT)) {
 			ath_dbg(common, ATH_DBG_CALIBRATE,
-				"offset calibration failed to complete in 1ms; noisy ??\n");
+				"offset calibration failed to complete in 1ms; noisy environment?\n");
 			return false;
 		}
 		REG_CLR_BIT(ah, AR_PHY_TURBO, AR_PHY_FC_DYN2040_EN);
@@ -734,7 +734,7 @@ static bool ar9285_hw_cl_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 	if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
 			  0, AH_WAIT_TIMEOUT)) {
 		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"offset calibration failed to complete in 1ms; noisy ??\n");
+			"offset calibration failed to complete in 1ms; noisy environment?\n");
 		return false;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 35b1a8c..939fc7a 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -90,7 +90,7 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 				}
 			} else {
 				ath_err(common,
-					"Invalid EEPROM Magic. endianness mismatch.\n");
+					"Invalid EEPROM Magic. Endianness mismatch.\n");
 				return -EINVAL;
 			}
 		}
@@ -1178,7 +1178,7 @@ static u16 ath9k_hw_4k_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 	u16 spur_val = AR_NO_SPUR;
 
 	ath_dbg(common, ATH_DBG_ANI,
-		"Getting spur idx %d is2Ghz. %d val %x\n",
+		"Getting spur idx:%d is2Ghz:%d val:%x\n",
 		i, is2GHz, ah->config.spurchans[i][is2GHz]);
 
 	switch (ah->config.spurmode) {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 0be5351..9ec4bc8 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -1150,7 +1150,7 @@ static u16 ath9k_hw_ar9287_get_spur_channel(struct ath_hw *ah,
 	u16 spur_val = AR_NO_SPUR;
 
 	ath_dbg(common, ATH_DBG_ANI,
-		"Getting spur idx %d is2Ghz. %d val %x\n",
+		"Getting spur idx:%d is2Ghz:%d val:%x\n",
 		i, is2GHz, ah->config.spurchans[i][is2GHz]);
 
 	switch (ah->config.spurmode) {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 91722fb..9aa31aa 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -1458,7 +1458,7 @@ static u16 ath9k_hw_def_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 	u16 spur_val = AR_NO_SPUR;
 
 	ath_dbg(common, ATH_DBG_ANI,
-		"Getting spur idx %d is2Ghz. %d val %x\n",
+		"Getting spur idx:%d is2Ghz:%d val:%x\n",
 		i, is2GHz, ah->config.spurchans[i][is2GHz]);
 
 	switch (ah->config.spurmode) {
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index c41ab8c..69b6aca 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -239,7 +239,7 @@ int htc_connect_service(struct htc_target *target,
 	/* Find an available endpoint */
 	endpoint = get_next_avail_ep(target->endpoint);
 	if (!endpoint) {
-		dev_err(target->dev, "Endpoint is not available for"
+		dev_err(target->dev, "Endpoint is not available for "
 			"service %d\n", service_connreq->service_id);
 		return -EINVAL;
 	}
@@ -253,7 +253,7 @@ int htc_connect_service(struct htc_target *target,
 	skb = alloc_skb(sizeof(struct htc_conn_svc_msg) +
 			    sizeof(struct htc_frame_hdr), GFP_ATOMIC);
 	if (!skb) {
-		dev_err(target->dev, "Failed to allocate buf to send"
+		dev_err(target->dev, "Failed to allocate buf to send "
 			"service connect req\n");
 		return -ENOMEM;
 	}
@@ -434,7 +434,7 @@ struct htc_target *ath9k_htc_hw_alloc(void *hif_handle,
 
 	target = kzalloc(sizeof(struct htc_target), GFP_KERNEL);
 	if (!target) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		printk(KERN_ERR "Unable to allocate memory for "
 			"target device\n");
 		return NULL;
 	}
-- 
1.7.3.2.245.g03276.dirty


