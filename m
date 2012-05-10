Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab2EJHqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 03:46:03 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8572 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130Ab2EJHp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 03:45:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 10 May 2012 00:45:54 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <hdoyu@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Simon Glass <sjg@chromium.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] ARM: dt: tegra20.dtsi: Add GART node
Date: Thu, 10 May 2012 10:45:33 +0300
Message-ID: <1336635940-31068-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336635940-31068-1-git-send-email-hdoyu@nvidia.com>
References: <1336635940-31068-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a node for the Tegra20 GART

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 arch/arm/boot/dts/tegra20.dtsi |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 548b42e..c6cf42e 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -207,6 +207,12 @@
 		phy_type = "utmi";
 	};
 
+	gart {
+		compatible = "nvidia,tegra20-gart";
+		reg = <0x7000f024 0x00000018	/* controller registers */
+		       0x58000000 0x02000000>;	/* GART aperture */
+	};
+
 	ahb: ahb@6000c004 {
 		compatible = "nvidia,tegra20-ahb";
 		reg = <0x6000c004 0x10c>; /* AHB Arbitration + Gizmo Controller */
-- 
1.7.5.4

