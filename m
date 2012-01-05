Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab2AEDm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:42:58 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:51152 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932247Ab2AEDmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:42:52 -0500
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>, linux-kernel@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 6/7] rtlwifi: Remove duplicate __func__
Date: Wed,  4 Jan 2012 19:40:44 -0800
Message-Id: <423eb9a5e773ff865997dbef580c3b741dc45a8a.1325734203.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1325734202.git.joe@perches.com>
References: <cover.1325734202.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RT_TRACE macro already prepends it.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index aca0fd5..7d5f799 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -620,7 +620,7 @@ void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
 		SET_TX_DESC_BMC(txdesc, 1);
 	_rtl_fill_usb_tx_desc(txdesc);
 	_rtl_tx_desc_checksum(txdesc);
-	RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE, " %s ==>\n", __func__);
+	RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE, "==>\n");
 }
 
 void rtl92cu_fill_fake_txdesc(struct ieee80211_hw *hw, u8 * pDesc,
-- 
1.7.8.111.gad25c.dirty

