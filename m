Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab2DDP2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 11:28:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36868 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab2DDP2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 11:28:00 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V4 REPOST 3/5] dt: Move Tegra20 pin mux binding into new pinctrl directory
Date: Wed,  4 Apr 2012 09:27:48 -0600
Message-Id: <1333553270-9040-3-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1333553270-9040-1-git-send-email-swarren@wwwdotorg.org>
References: <1333553270-9040-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

This places the file in the new location for all pin controller bindings.

Also, rename the file using the full compatible value for easier
avoidance of conflicts between multiple bindings.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
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

