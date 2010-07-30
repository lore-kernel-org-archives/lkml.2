Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab0G3A6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 20:58:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38816 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319Ab0G3A6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 20:58:36 -0400
Date: Fri, 30 Jul 2010 10:58:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Erik Gilling <konkers@android.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Changhwan Youn <chaos.youn@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the tegra tree with the s5p tree
Message-Id: <20100730105834.d7ac047f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tegra tree got a conflict in
arch/arm/mm/Kconfig between commit
9d2ef2d3944bb387df220fdeec93abc38b62b627 ("ARM: S5PV310: Add new Kconfig
and Makefiles") from the s5p tree and commit
7e3b9536bd5ba23b3c94055bdf8c2fd45d9f8e62 ("[ARM] tegra: initial tegra
support") from the tegra tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mm/Kconfig
index d6ffcee,aa26573..0000000
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@@ -772,7 -783,7 +772,7 @@@ config CACHE_L2X
  	depends on REALVIEW_EB_ARM11MP || MACH_REALVIEW_PB11MP || MACH_REALVIEW_PB1176 || \
  		   REALVIEW_EB_A9MP || ARCH_MX35 || ARCH_MX31 || MACH_REALVIEW_PBX || \
  		   ARCH_NOMADIK || ARCH_OMAP4 || ARCH_U8500 || ARCH_VEXPRESS_CA9X4 || \
- 		   ARCH_S5PV310
 -		   ARCH_TEGRA
++		   ARCH_S5PV310 || ARCH_TEGRA
  	default y
  	select OUTER_CACHE
  	select OUTER_CACHE_SYNC
