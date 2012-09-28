Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031434Ab2I1Thz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:37:55 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38829 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031402Ab2I1Tht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:37:49 -0400
From: Matt Porter <mporter@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Benoit Cousson <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sekhar Nori <nsekhar@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: [PATCH v2 3/7] uio: dt: add TI PRUSS binding
Date: Fri, 28 Sep 2012 15:37:48 -0400
Message-Id: <1348861072-14507-4-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348861072-14507-1-git-send-email-mporter@ti.com>
References: <1348861072-14507-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a DT binding definition for the TI PRUSS.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 Documentation/devicetree/bindings/uio/pruss.txt |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/uio/pruss.txt

diff --git a/Documentation/devicetree/bindings/uio/pruss.txt b/Documentation/devicetree/bindings/uio/pruss.txt
new file mode 100644
index 0000000..2ac45c5
--- /dev/null
+++ b/Documentation/devicetree/bindings/uio/pruss.txt
@@ -0,0 +1,17 @@
+TI PRUSS device
+
+Required properties:
+- compatible :
+  - "ti,pruss-v1" for AM18xx/OMAP-L138/DA850
+  - "ti,pruss-v2" for AM33xx.
+- ti,pintc-offset : Offset of the PINTC from the PRUSS address base
+- ti,hwmods: Name of the hwmod associated to the PRUSS
+
+Example:
+
+pruss: pruss@4a300000 {
+	compatible = "ti,pruss-v2";
+	ti,hwmods = "pruss";
+	reg = <0x4a300000 0x080000>;
+	ti,pintc-offset = <0x20000>;
+};
-- 
1.7.9.5

