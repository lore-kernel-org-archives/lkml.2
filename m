Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab1HRTND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:13:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48432 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab1HRTMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:12:51 -0400
Date: Thu, 18 Aug 2011 20:12:50 +0100
To: richard@nod.at
Subject: Subject: [PATCH 83/91] um: a couple of missing dependencies...
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu81K-00085s-2q@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/wireless/ath/Kconfig     |    2 +-
 drivers/net/wireless/rtlwifi/Kconfig |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index d1b2306..47d0de8 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -1,6 +1,6 @@
 menuconfig ATH_COMMON
 	tristate "Atheros Wireless Cards"
-	depends on CFG80211
+	depends on CFG80211 && (!UML || BROKEN)
 	---help---
 	  This will enable the support for the Atheros wireless drivers.
 	  ath5k, ath9k, ath9k_htc and ar9170 drivers share some common code, this option
diff --git a/drivers/net/wireless/rtlwifi/Kconfig b/drivers/net/wireless/rtlwifi/Kconfig
index 45e1476..d6c42e6 100644
--- a/drivers/net/wireless/rtlwifi/Kconfig
+++ b/drivers/net/wireless/rtlwifi/Kconfig
@@ -12,7 +12,7 @@ config RTL8192CE
 
 config RTL8192SE
 	tristate "Realtek RTL8192SE/RTL8191SE PCIe Wireless Network Adapter"
-	depends on MAC80211 && EXPERIMENTAL
+	depends on MAC80211 && EXPERIMENTAL && PCI
 	select FW_LOADER
 	select RTLWIFI
 	---help---
@@ -23,7 +23,7 @@ config RTL8192SE
 
 config RTL8192DE
 	tristate "Realtek RTL8192DE/RTL8188DE PCIe Wireless Network Adapter"
-	depends on MAC80211 && EXPERIMENTAL
+	depends on MAC80211 && EXPERIMENTAL && PCI
 	select FW_LOADER
 	select RTLWIFI
 	---help---
-- 
1.7.2.5


