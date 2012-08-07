Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab2HGXew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:34:52 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:56716 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631Ab2HGW3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:29:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 051/122] iwlwifi: fix debug print in iwl_sta_calc_ht_flags
Date: Tue,  7 Aug 2012 15:25:39 -0700
Message-Id: <20120807221952.819099514@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

commit a35e270881a5db1ec9ac8bc6d61ebc3e85c14f33 upstream.

We missed passing an argument to the
debug print. Fix it.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -236,6 +236,7 @@ static void iwl_sta_calc_ht_flags(struct
 	mimo_ps_mode = (sta_ht_inf->cap & IEEE80211_HT_CAP_SM_PS) >> 2;
 
 	IWL_DEBUG_INFO(priv, "STA %pM SM PS mode: %s\n",
+			sta->addr,
 			(mimo_ps_mode == WLAN_HT_CAP_SM_PS_STATIC) ?
 			"static" :
 			(mimo_ps_mode == WLAN_HT_CAP_SM_PS_DYNAMIC) ?


