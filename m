Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab1I1Bpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 21:45:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51897 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab1I1Bpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 21:45:36 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 2/2] devicetree: Add ARM pl022 spi controller binding doc
Date: Tue, 27 Sep 2011 20:45:14 -0500
Message-Id: <1317174314-16122-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317174314-16122-1-git-send-email-robherring2@gmail.com>
References: <1317174314-16122-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Add binding documentation for ARM's Primecell PL022 SPI controller.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 .../devicetree/bindings/spi/spi_pl022.txt          |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/spi_pl022.txt

diff --git a/Documentation/devicetree/bindings/spi/spi_pl022.txt b/Documentation/devicetree/bindings/spi/spi_pl022.txt
new file mode 100644
index 0000000..306ec3f
--- /dev/null
+++ b/Documentation/devicetree/bindings/spi/spi_pl022.txt
@@ -0,0 +1,12 @@
+ARM PL022 SPI controller
+
+Required properties:
+- compatible : "arm,pl022", "arm,primecell"
+- reg : Offset and length of the register set for the device
+- interrupts : Should contain SPI controller interrupt
+
+Optional properties:
+- cs-gpios : should specify GPIOs used for chipselects.
+  The gpios will be referred to as reg = <index> in the SPI child nodes.
+  If unspecified, a single SPI device without a chip select can be used.
+
-- 
1.7.5.4

