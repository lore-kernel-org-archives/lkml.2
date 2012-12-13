Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab2LMOFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:05:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44314 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab2LMOFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:05:21 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pritesh Raithatha <praithatha@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 075/241] ARM: dt: tegra: fix length of pad control and mux registers
Date: Thu, 13 Dec 2012 11:57:20 -0200
Message-Id: <1355407206-17100-76-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pritesh Raithatha <praithatha@nvidia.com>

commit 322337b8fbd8c392246529d5db924820fc0c7381 upstream.

The reg property contains <base length> not <base last_offset>. Fix
the length values to be length not last_offset.

Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/arm/boot/dts/tegra30.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index 2dcc09e..15e6c85 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -73,8 +73,8 @@
 
 	pinmux: pinmux {
 		compatible = "nvidia,tegra30-pinmux";
-		reg = <0x70000868 0xd0    /* Pad control registers */
-		       0x70003000 0x3e0>; /* Mux registers */
+		reg = <0x70000868 0xd4    /* Pad control registers */
+		       0x70003000 0x3e4>; /* Mux registers */
 	};
 
 	serial@70006000 {
-- 
1.7.9.5

