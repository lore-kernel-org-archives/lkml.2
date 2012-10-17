Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab2JQLhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 07:37:23 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11697 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab2JQLhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 07:37:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 17 Oct 2012 04:37:15 -0700
From: Pritesh Raithatha <praithatha@nvidia.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <swarren@nvidia.com>, <linus.walleij@linaro.org>,
        <dong.aisheng@linaro.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <praithatha@nvidia.com>
Subject: [PATCH 1/2] dt: Document: correct tegra20/30 pinctrl slew-rate name
Date: Wed, 17 Oct 2012 17:07:00 +0530
Message-ID: <1350473820-25662-1-git-send-email-praithatha@nvidia.com>
X-Mailer: git-send-email 1.7.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change nvidia,slew_rate* to nvidia,slew-rate*

Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
---
 .../bindings/pinctrl/nvidia,tegra20-pinmux.txt     |    2 +-
 .../bindings/pinctrl/nvidia,tegra30-pinmux.txt     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt
index c8e5782..683fde9 100644
--- a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt
+++ b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt
@@ -93,7 +93,7 @@ Valid values for pin and group names are:
 
     With some exceptions, these support nvidia,high-speed-mode,
     nvidia,schmitt, nvidia,low-power-mode, nvidia,pull-down-strength,
-    nvidia,pull-up-strength, nvidia,slew_rate-rising, nvidia,slew_rate-falling.
+    nvidia,pull-up-strength, nvidia,slew-rate-rising, nvidia,slew-rate-falling.
 
     drive_ao1, drive_ao2, drive_at1, drive_at2, drive_cdev1, drive_cdev2,
     drive_csus, drive_dap1, drive_dap2, drive_dap3, drive_dap4, drive_dbg,
diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra30-pinmux.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra30-pinmux.txt
index c275b70..6f426ed 100644
--- a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra30-pinmux.txt
+++ b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra30-pinmux.txt
@@ -83,7 +83,7 @@ Valid values for pin and group names are:
   drive groups:
 
     These all support nvidia,pull-down-strength, nvidia,pull-up-strength,
-    nvidia,slew_rate-rising, nvidia,slew_rate-falling. Most but not all
+    nvidia,slew-rate-rising, nvidia,slew-rate-falling. Most but not all
     support nvidia,high-speed-mode, nvidia,schmitt, nvidia,low-power-mode.
 
     ao1, ao2, at1, at2, at3, at4, at5, cdev1, cdev2, cec, crt, csus, dap1,
-- 
1.7.1

