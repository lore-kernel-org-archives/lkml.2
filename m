Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab2EIGOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:14:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39151 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756680Ab2EIFx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:29 -0400
Message-Id: <20120509055052.053116760@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:53:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 163/167] [PATCH] iwlwifi: use 6000G2B for 6030 device series
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit 1ed2ec37b44e86eaa8e0a03b908a39c80f65ee45 upstream.

"iwlwifi: use correct released ucode version" change
the ucode api ok from 6000G2 to 6000G2B, but it shall belong
to 6030 device series, not the 6005 device series. Fix it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux.orig/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ linux/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -361,7 +361,7 @@
 #define IWL_DEVICE_6005						\
 	.fw_name_pre = IWL6005_FW_PRE,				\
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
-	.ucode_api_ok = IWL6000G2B_UCODE_API_OK,		\
+	.ucode_api_ok = IWL6000G2_UCODE_API_OK,			\
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
 	.eeprom_ver = EEPROM_6005_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6005_TX_POWER_VERSION,	\
@@ -402,7 +402,7 @@
 #define IWL_DEVICE_6030						\
 	.fw_name_pre = IWL6030_FW_PRE,				\
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
-	.ucode_api_ok = IWL6000G2_UCODE_API_OK,			\
+	.ucode_api_ok = IWL6000G2B_UCODE_API_OK,		\
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
 	.eeprom_ver = EEPROM_6030_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6030_TX_POWER_VERSION,	\


