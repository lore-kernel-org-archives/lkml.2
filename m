Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770Ab2KZRg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:36:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47920 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933684Ab2KZRLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:11:47 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pritesh Raithatha <praithatha@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 190/270] dt: Document: correct tegra20/30 pinctrl slew-rate name
Date: Mon, 26 Nov 2012 14:58:00 -0200
Message-Id: <1353949160-26803-191-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pritesh Raithatha <praithatha@nvidia.com>

commit d6ec6b60a56a1e7d99da1fc69c031fa5ab54ba94 upstream.

change nvidia,slew_rate* to nvidia,slew-rate*

Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
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
1.7.9.5

