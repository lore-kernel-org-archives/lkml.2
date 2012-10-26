Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab2JZAQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:16:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:53895 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540Ab2JZAIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Pritesh Raithatha <praithatha@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [ 54/85] dt: Document: correct tegra20/30 pinctrl slew-rate name
Date: Thu, 25 Oct 2012 17:06:12 -0700
Message-Id: <20121026000036.545973192@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pritesh Raithatha <praithatha@nvidia.com>

commit d6ec6b60a56a1e7d99da1fc69c031fa5ab54ba94 upstream.

change nvidia,slew_rate* to nvidia,slew-rate*

Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt |    2 +-
 Documentation/devicetree/bindings/pinctrl/nvidia,tegra30-pinmux.txt |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt
+++ b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt
@@ -93,7 +93,7 @@ Valid values for pin and group names are
 
     With some exceptions, these support nvidia,high-speed-mode,
     nvidia,schmitt, nvidia,low-power-mode, nvidia,pull-down-strength,
-    nvidia,pull-up-strength, nvidia,slew_rate-rising, nvidia,slew_rate-falling.
+    nvidia,pull-up-strength, nvidia,slew-rate-rising, nvidia,slew-rate-falling.
 
     drive_ao1, drive_ao2, drive_at1, drive_at2, drive_cdev1, drive_cdev2,
     drive_csus, drive_dap1, drive_dap2, drive_dap3, drive_dap4, drive_dbg,
--- a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra30-pinmux.txt
+++ b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra30-pinmux.txt
@@ -83,7 +83,7 @@ Valid values for pin and group names are
   drive groups:
 
     These all support nvidia,pull-down-strength, nvidia,pull-up-strength,
-    nvidia,slew_rate-rising, nvidia,slew_rate-falling. Most but not all
+    nvidia,slew-rate-rising, nvidia,slew-rate-falling. Most but not all
     support nvidia,high-speed-mode, nvidia,schmitt, nvidia,low-power-mode.
 
     ao1, ao2, at1, at2, at3, at4, at5, cdev1, cdev2, cec, crt, csus, dap1,


