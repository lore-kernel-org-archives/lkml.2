Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab2HTQng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:43:36 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:32866 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab2HTQm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:42:57 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: ben@decadent.org.uk
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        dwmw2@infradead.org, Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] rtlwifi/rtl8723e: Add firmware for new driver
Date: Mon, 20 Aug 2012 11:42:30 -0500
Message-Id: <1345480950-11107-1-git-send-email-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver and firmware are new additions to the rtlwifi family of drivers.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 WHENCE                  |   10 ++++++++++
 rtlwifi/rtl8723fw.bin   |  Bin 0 -> 11662 bytes
 rtlwifi/rtl8723fw_B.bin |  Bin 0 -> 22996 bytes
 3 files changed, 10 insertions(+)
 create mode 100755 rtlwifi/rtl8723fw.bin
 create mode 100755 rtlwifi/rtl8723fw_B.bin

diff --git a/WHENCE b/WHENCE
index b4de6be..0f3c828 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1790,6 +1790,16 @@ Licence: Redistributable. See LICENCE.rtlwifi_firmware.txt for details.
 
 --------------------------------------------------------------------------
 
+Driver: rtl8723e - Realtek 802.11n WLAN driver for RTL8723E
+
+Info: Taken from Realtek version rtl_92ce_92se_92de_8723ae_linux_mac80211_0007.0809.2012
+File: rtlwifi/rtl8723fw.bin
+File: rtlwifi/rtl8723fw_B.bin
+
+Licence: Redistributable. See LICENCE.rtlwifi_firmware.txt for details.
+
+--------------------------------------------------------------------------
+
 
 Driver: r8169 - RealTek 8169/8168/8101 ethernet driver.
 
diff --git a/rtlwifi/rtl8723fw.bin b/rtlwifi/rtl8723fw.bin
new file mode 100755
index 0000000000000000000000000000000000000000..725f2138e1c0134bcb094594e9ea0e30dce08e6d
GIT binary patch
literal 11662
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
XXunOniH4;w9rbdXIon**&~yI>;CE6N

literal 0
HcmV?d00001

diff --git a/rtlwifi/rtl8723fw_B.bin b/rtlwifi/rtl8723fw_B.bin
new file mode 100755
index 0000000000000000000000000000000000000000..993c7f6ecea30c5bae914c4c22152735d8eb0d61
GIT binary patch
literal 22996
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
VWoNt<fy5$)n~<CDN%0Il``>zih93X`

literal 0
HcmV?d00001

-- 
1.7.10.4

