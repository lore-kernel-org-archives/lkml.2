Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422817Ab2CPUzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:55:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60854 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161572Ab2CPUzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:55:01 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH 6/8] dt: Move Tegra20 pin mux binding into new pinctrl directory
Date: Fri, 16 Mar 2012 14:54:27 -0600
Message-Id: <1331931269-12262-6-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331931269-12262-1-git-send-email-swarren@wwwdotorg.org>
References: <1331931269-12262-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This places the file in the new location for all pin controller bindings.

Also, rename the file using the full compatible value for easier
avoidance of conflicts between multiple bindings.

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
---
 .../bindings/pinctrl/nvidia,tegra20-pinmux.txt     |    5 +++++
 .../devicetree/bindings/pinmux/pinmux_nvidia.txt   |    5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt
 delete mode 100644 Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt
new file mode 100644
index 0000000..36f82db
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt
@@ -0,0 +1,5 @@
+NVIDIA Tegra 2 pinmux controller
+
+Required properties:
+- compatible : "nvidia,tegra20-pinmux"
+
diff --git a/Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt b/Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt
deleted file mode 100644
index 36f82db..0000000
--- a/Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt
+++ /dev/null
@@ -1,5 +0,0 @@
-NVIDIA Tegra 2 pinmux controller
-
-Required properties:
-- compatible : "nvidia,tegra20-pinmux"
-
-- 
1.7.0.4

