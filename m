Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab2LUCoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:44:23 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:53469 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab2LUCoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:44:14 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 21:44:13 EST
From: Larry Finger <Larry.Finger@lwfinger.net>
To: ben@decadent.org.uk
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        dwmw2@infradead.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Champion Chen <champion_chen@realsil.com.cn>
Subject: [PATCH] rtk_btusb: Add Bluetooth firmware
Date: Thu, 20 Dec 2012 20:37:45 -0600
Message-Id: <1356057465-15669-1-git-send-email-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Champion Chen <champion_chen@realsil.com.cn>
---
 WHENCE              |    8 ++++++++
 rtl_bt/rtl8723a.bin |  Bin 0 -> 23772 bytes
 2 files changed, 8 insertions(+)
 create mode 100644 rtl_bt/rtl8723a.bin

diff --git a/WHENCE b/WHENCE
index 3b2f282..f485111 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1811,6 +1811,14 @@ Licence: Redistributable. See LICENCE.rtlwifi_firmware.txt for details.
 
 --------------------------------------------------------------------------
 
+Driver: rtk_btusb - Realtek Bluetooth driver
+
+Info: Supplied by champion_chen@realsil.com.cn along with driver source code
+File: rtl_bt/rtl8723a.bin
+
+Licence: Redistributable. See LICENCE.rtlwifi_firmware.txt for details.
+
+--------------------------------------------------------------------------
 
 Driver: r8169 - RealTek 8169/8168/8101 ethernet driver.
 
diff --git a/rtl_bt/rtl8723a.bin b/rtl_bt/rtl8723a.bin
new file mode 100644
index 0000000000000000000000000000000000000000..1a43ce2e9585f83434d15503b36049584657b81f
GIT binary patch
literal 23772
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

literal 0
HcmV?d00001

-- 
1.7.10.4

