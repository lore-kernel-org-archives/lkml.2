Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab2FNG6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 02:58:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33288 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2FNG6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 02:58:42 -0400
From: Woody Hung <Woody.Hung@mediatek.com>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, xose.vazquez@gmail.com, ben@decadent.org.uk,
        users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
        Woody Hung <Woody.Hung@mediatek.com>
Subject: [PATCH] rt2800pci:Firmware update v1
Date: Thu, 14 Jun 2012 14:57:41 +0800
Message-Id: <1339657061-19482-1-git-send-email-Woody.Hung@mediatek.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update firmwrae that support the rt3290 chip.

Signed-off-by: Woody Hung <Woody.Hung@mediatek.com>
---
 WHENCE     |    4 +++-
 rt3290.bin |  Bin 0 -> 4096 bytes
 2 files changed, 3 insertions(+), 1 deletions(-)
 create mode 100644 rt3290.bin

diff --git a/WHENCE b/WHENCE
index 5512440..7ce80ad 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1182,13 +1182,15 @@ Downloaded from http://www.ralinktech.com/ralink/Home/Support/Linux.html
 
 --------------------------------------------------------------------------
 
-Driver: rt2800pci - Ralink RT2860, RT2890, RT3090, RT5390 wireless MACs
+Driver: rt2800pci - Ralink RT2860, RT2890, RT3090, RT3290, RT5390 wireless MACs
 
 File: rt2860.bin
+File: rt3290.bin
 
 Licence: Redistributable. See LICENCE.ralink-firmware.txt for details
 
 Binary file supplied by Shiang Tu <shiang_tu@ralinktech.com>. Firmware Version 34
+rt3290.bin is a specific firmware support the RT3290 chip. Firmware Version 37
 
 --------------------------------------------------------------------------
 
diff --git a/rt3290.bin b/rt3290.bin
new file mode 100644
index 0000000000000000000000000000000000000000..6ca33a59950e80ba27d29ab8df7acd7c12915ac8
GIT binary patch
literal 4096
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
T@+=C4#oC|e|Lm_d_S63W=k%O=

literal 0
HcmV?d00001

-- 
1.7.5.4

