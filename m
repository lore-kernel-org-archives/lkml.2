Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab1DLOrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:47:53 -0400
Received: from kroah.org ([198.145.64.141]:57677 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311Ab1DLOi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:28 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:55 2011
Message-Id: <20110412143555.031867445@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "John W. Linville" <linville@tuxdriver.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [066/105] iwlwifi: accept EEPROM version 0x423 for iwl6000
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John W. Linville <linville@tuxdriver.com>

commit 3d7dc7e8c1566acb0fc55df228b2ed91f5638e9d upstream.

A number of these devices have appeared "in the wild", and apparently
the Windows driver is perfectly happy to support this EEPROM version.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -241,7 +241,7 @@ struct iwl_eeprom_enhanced_txpwr {
 
 /* 6x00 Specific */
 #define EEPROM_6000_TX_POWER_VERSION    (4)
-#define EEPROM_6000_EEPROM_VERSION	(0x434)
+#define EEPROM_6000_EEPROM_VERSION	(0x423)
 
 /* 6x50 Specific */
 #define EEPROM_6050_TX_POWER_VERSION    (4)


