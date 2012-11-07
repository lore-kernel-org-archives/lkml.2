Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab2KGUzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 15:55:54 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52723 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab2KGUzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 15:55:51 -0500
From: Marek Belisko <marek.belisko@open-nandra.com>
To: cooloney@gmail.com, rpurdie@rpsys.net
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 2/2] Add documentation for tca6507 devicetree bindings.
Date: Wed,  7 Nov 2012 21:55:26 +0100
Message-Id: <1352321726-21284-2-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352321726-21284-1-git-send-email-marek.belisko@open-nandra.com>
References: <1352321726-21284-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 Documentation/devicetree/bindings/leds/tca6507.txt |   33 ++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/tca6507.txt

diff --git a/Documentation/devicetree/bindings/leds/tca6507.txt b/Documentation/devicetree/bindings/leds/tca6507.txt
new file mode 100644
index 0000000..cb0015b9f
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/tca6507.txt
@@ -0,0 +1,33 @@
+LEDs conected to tca6507
+
+Required properties:
+- compatible : should be : "leds-tca6507".
+
+Each led is represented as a sub-node of the leds-tca6507 device.
+
+LED sub-node properties:
+- label : label for this LED
+- reg : number of LED line (could be from 0 to 6)
+- linux,default-trigger : led default trigger
+
+Examples:
+
+tca6507@45 {
+	compatible = "leds-tca6507";
+	#address-cells = <1>;
+	#size-cells = <0>;
+	reg = <0x45>;
+
+	led0: red_aux@0 {
+		label = "red:aux";
+		reg = <0x0>;
+	};
+
+	led1: green_aux@1 {
+		label = "green:aux";
+		reg = <0x5>;
+		linux,default-trigger = "default-on";
+	};
+
+};
+
-- 
1.7.9.5

