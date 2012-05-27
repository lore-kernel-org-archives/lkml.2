Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab2E0BHA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:07:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38960 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184Ab2E0BGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:06:55 -0400
Message-Id: <20120527010425.194805088@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:04:33 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 10/94] iwlwifi: use 6000G2B for 6030 device series
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit 35e7adaaf6932c5ffb22c6ec521734434c65adc5 upstream.

"iwlwifi: use correct released ucode version" change
the ucode api ok from 6000G2 to 6000G2B, but it shall belong
to 6030 device series, not the 6005 device series. Fix it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -391,7 +391,7 @@ struct iwl_cfg iwl6005_2agn_d_cfg = {
 #define IWL_DEVICE_6030						\
 	.fw_name_pre = IWL6030_FW_PRE,				\
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
-	.ucode_api_ok = IWL6000G2B_UCODE_API_OK,		\
+	.ucode_api_ok = IWL6000G2_UCODE_API_OK,			\
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
 	.eeprom_ver = EEPROM_6030_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6030_TX_POWER_VERSION,	\


