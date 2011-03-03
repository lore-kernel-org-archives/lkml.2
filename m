Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025Ab1CCXmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 18:42:10 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48290 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758739Ab1CCXmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 18:42:08 -0500
Date: Fri, 4 Mar 2011 10:42:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Zhao <richard.zhao@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: linux-next: manual merge of the s5p tree with the i.MX tree
Message-Id: <20110304104206.d2feadef.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
arch/arm/mm/Kconfig between commit
4d2f13be1e370a670c1cae20c194d5ce961e0fa5 ("ARM: imx3x: clean up
ARCH_MX3X") from the i.MX tree and commit
10606aadb046d008c88d1a99b309357ca33d590e ("ARM: EXYNOS4: Update Kconfig
and Makefile for the new ARCH_EXYNOS4") from the s5p tree.

Just context changes. I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mm/Kconfig
index 08daea9,0f59e54..0000000
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@@ -819,8 -811,8 +819,8 @@@ config CACHE_FEROCEON_L2_WRITETHROUG
  config CACHE_L2X0
  	bool "Enable the L2x0 outer cache controller"
  	depends on REALVIEW_EB_ARM11MP || MACH_REALVIEW_PB11MP || MACH_REALVIEW_PB1176 || \
 -		   REALVIEW_EB_A9MP || ARCH_MX35 || ARCH_MX31 || MACH_REALVIEW_PBX || \
 +		   REALVIEW_EB_A9MP || SOC_IMX35 || SOC_IMX31 || MACH_REALVIEW_PBX || \
- 		   ARCH_NOMADIK || ARCH_OMAP4 || ARCH_S5PV310 || ARCH_TEGRA || \
+ 		   ARCH_NOMADIK || ARCH_OMAP4 || ARCH_EXYNOS4 || ARCH_TEGRA || \
  		   ARCH_U8500 || ARCH_VEXPRESS_CA9X4 || ARCH_SHMOBILE
  	default y
  	select OUTER_CACHE
