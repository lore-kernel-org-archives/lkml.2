Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab1I1Bpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 21:45:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51897 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab1I1Bpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 21:45:34 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 1/2] devicetree: Add ARM pl061 gpio controller binding doc
Date: Tue, 27 Sep 2011 20:45:13 -0500
Message-Id: <1317174314-16122-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Add binding documentation for ARM's Primecell PL061 GPIO controller.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 .../devicetree/bindings/gpio/pl061-gpio.txt        |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/pl061-gpio.txt

diff --git a/Documentation/devicetree/bindings/gpio/pl061-gpio.txt b/Documentation/devicetree/bindings/gpio/pl061-gpio.txt
new file mode 100644
index 0000000..a2c416b
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/pl061-gpio.txt
@@ -0,0 +1,10 @@
+ARM PL061 GPIO controller
+
+Required properties:
+- compatible : "arm,pl061", "arm,primecell"
+- #gpio-cells : Should be two. The first cell is the pin number and the
+  second cell is used to specify optional parameters:
+  - bit 0 specifies polarity (0 for normal, 1 for inverted)
+- gpio-controller : Marks the device node as a GPIO controller.
+- interrupts : Interrupt mapping for GPIO IRQ.
+
-- 
1.7.5.4

