Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008Ab1CXT1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:27:50 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:63376 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933858Ab1CXT1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:27:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Gj/ZgIy5XH7HLNNyGDyrA6peLc/8F60nwujgY5RBIf4Pmv1BXBfV0ZQDYXd/SHhWDm
         VzeH9cZ6/xl7bsYhGibpUxGU3eySq8PtkVstvzubgHwsNs5sm1RdA1VvcVKaYRGCW+zB
         VA847HZIpaUS9jLfbb2IiqXTFtKeEY9NaQmUE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 11/21]drivers:net Remove extra comma.
Date: Thu, 24 Mar 2011 12:26:49 -0700
Message-Id: <1300994819-30930-11-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
References: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra comma from various parts 
of the kernel. Please have a look when you have time, and let
me know if its legit or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/can/softing/softing_main.c      |    2 +-
 drivers/net/wireless/ath/ath9k/phy.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/rtlwifi/core.c         |    2 +-
 drivers/net/wireless/rtlwifi/pci.c          |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c |    4 ++--
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/softing/softing_main.c
index aeea9f9..8d75953 100644
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -797,7 +797,7 @@ static __devinit int softing_pdev_probe(struct platform_device *pdev)
 	ret = -EINVAL;
 	pres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!pres)
-		goto platform_resource_failed;;
+		goto platform_resource_failed;
 	card->dpram_phys = pres->start;
 	card->dpram_size = pres->end - pres->start + 1;
 	card->dpram = ioremap_nocache(card->dpram_phys, card->dpram_size);
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index 5e3d749..3a7cd75 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -54,7 +54,7 @@
 #define RF_BANK_SETUP(_bank, _iniarray, _col) do {			\
 		int i;							\
 		for (i = 0; i < (_iniarray)->ia_rows; i++)		\
-			(_bank)[i] = INI_RA((_iniarray), i, _col);;	\
+			(_bank)[i] = INI_RA((_iniarray), i, _col);	\
 	} while (0)
 
 #define	AR_PHY_TIMING11_SPUR_FREQ_SD		0x3FF00000
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 581dc9f..31233a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2062,7 +2062,7 @@ static const char *desc_lookup(u32 num)
 	max = ARRAY_SIZE(advanced_lookup) - 1;
 	for (i = 0; i < max; i++) {
 		if (advanced_lookup[i].num == num)
-			break;;
+			break;
 	}
 	return advanced_lookup[i].name;
 }
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index e4f4aee..d52fa27 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -719,7 +719,7 @@ static void rtl_op_set_tsf(struct ieee80211_hw *hw, u64 tsf)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	u8 bibss = (mac->opmode == NL80211_IFTYPE_ADHOC) ? 1 : 0;;
+	u8 bibss = (mac->opmode == NL80211_IFTYPE_ADHOC) ? 1 : 0;
 
 	mac->tsf = tsf;
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_CORRECT_TSF, (u8 *) (&bibss));
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 9cd7703..baa2efe 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1226,7 +1226,7 @@ static unsigned int _rtl_mac_to_hwqueue(__le16 fc,
 		hw_queue_index = VI_QUEUE;
 		break;
 	case 2:
-		hw_queue_index = BE_QUEUE;;
+		hw_queue_index = BE_QUEUE;
 		break;
 	case 3:
 		hw_queue_index = BK_QUEUE;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index 05477f4..7432c85 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -729,7 +729,7 @@ static bool _rtl92ce_init_mac(struct ieee80211_hw *hw)
 	rtl_write_word(rtlpriv, REG_CR, 0x2ff);
 
 	if (_rtl92ce_llt_table_init(hw) == false)
-		return false;;
+		return false;
 
 	rtl_write_dword(rtlpriv, REG_HISR, 0xffffffff);
 	rtl_write_byte(rtlpriv, REG_HISRE, 0xff);
@@ -786,7 +786,7 @@ static bool _rtl92ce_init_mac(struct ieee80211_hw *hw)
 
 	rtl_write_dword(rtlpriv, REG_MCUTST_1, 0x0);
 
-	return true;;
+	return true;
 }
 
 static void _rtl92ce_hw_configure(struct ieee80211_hw *hw)
-- 
1.7.4.1

