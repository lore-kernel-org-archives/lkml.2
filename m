Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491Ab2FHOCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:02:43 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:43345 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757666Ab2FHOCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:02:39 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Russell King <linux@arm.linux.org.uk>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-omap@vger.kernel.org,
        Rajendra Nayak <rnayak@ti.com>, Liam Girdwood <lrg@ti.com>
Subject: [PATCH 7/7] arm/dts: New dts file for PandaBoardES (4460)
Date: Fri,  8 Jun 2012 17:02:05 +0300
Message-Id: <1339164125-32534-8-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339164125-32534-1-git-send-email-peter.ujfalusi@ti.com>
References: <1339164125-32534-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 4430 and 4460 version of PandaBoard mostly the same with
exception at least in audio setup.
Use the omap4-panda.dts file as a base and only override the differences
between the revisions.
For audio it is the name of the sound card and the routing information.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/boot/dts/omap4-pandaES.dts |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/omap4-pandaES.dts

diff --git a/arch/arm/boot/dts/omap4-pandaES.dts b/arch/arm/boot/dts/omap4-pandaES.dts
new file mode 100644
index 0000000..d4ba43a
--- /dev/null
+++ b/arch/arm/boot/dts/omap4-pandaES.dts
@@ -0,0 +1,24 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+/include/ "omap4-panda.dts"
+
+/* Audio routing is differnet between PandaBoard4430 and PandaBoardES */
+&sound {
+	ti,model = "PandaBoardES";
+
+	/* Audio routing */
+	ti,audio-routing =
+		"Headset Stereophone", "HSOL",
+		"Headset Stereophone", "HSOR",
+		"Ext Spk", "HFL",
+		"Ext Spk", "HFR",
+		"Line Out", "AUXL",
+		"Line Out", "AUXR",
+		"AFML", "Line In",
+		"AFMR", "Line In";
+};
-- 
1.7.8.6

