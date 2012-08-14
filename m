Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab2HNQXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 12:23:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40184 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab2HNQXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 12:23:41 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Sourav Poddar <sourav.poddar@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH] Documentation: dt: hwmon: Update for tmp102
Date: Tue, 14 Aug 2012 21:53:32 +0530
Message-ID: <1344961412-13622-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Documentation for tmp102 temperature sensor.

Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 Documentation/devicetree/bindings/hwmon/tmp102.txt |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hwmon/tmp102.txt

diff --git a/Documentation/devicetree/bindings/hwmon/tmp102.txt b/Documentation/devicetree/bindings/hwmon/tmp102.txt
new file mode 100644
index 0000000..df1342b
--- /dev/null
+++ b/Documentation/devicetree/bindings/hwmon/tmp102.txt
@@ -0,0 +1,11 @@
+TMP102 Temperature sensor
+
+Required properties:
+- compatible: ti,tmp102
+
+Example:
+
+tmp102@48 {
+        compatible = "ti,tmp102";
+        reg = <0x48>;
+};
-- 
1.7.1

