Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122Ab2CWROH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 13:14:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758996Ab2CWROE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 13:14:04 -0400
From: mathieu.poirier@linaro.org
To: tony@atomide.com
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: [PATCH 0/9] omap randconfig fixes for v3.3
Date: Fri, 23 Mar 2012 11:13:47 -0600
Message-Id: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Arnd Bergmann" <arnd@arndb.de>

The following is a set of patches that have been sent
out during the 3.1 cycle that were not acked or merged.

Sending again for completeness.  

Tony, please pull if there are no objections:

The following changes since commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7:

  Linux 3.3 (2012-03-18 16:15:34 -0700)

are available in the git repository at:
  git://git.linaro.org/people/mpoirier/linux.git randconfig-omap
 

Arnd Bergmann (8):
  arm/omap: enable building omap2 without omap2420/2430
  omap: fix visibility of omap2_mbox_iva_priv
  ARM: omap2+: fix building without i2c
  tty/serial/omap: console can only be built-in
  omap2: select twl4030 support on boards that need it
  omap2plus: ensure that one of omap2/3/4 is selected
  arm: OMAP depends on MMU
  ARM: omap: select CPU_FREQ_TABLE where needed

Russell King (1):
  ARM: omap2/n8x0: work around modular omap mmc

 arch/arm/Kconfig                           |    1 +
 arch/arm/mach-omap2/Kconfig                |   19 +++++++++++++++++++
 arch/arm/mach-omap2/board-n8x0.c           |    6 ++++--
 arch/arm/mach-omap2/mailbox.c              |    2 +-
 arch/arm/mach-omap2/omap_hwmod_2420_data.c |    2 +-
 arch/arm/mach-omap2/omap_hwmod_2430_data.c |    2 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |    2 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    2 +-
 arch/arm/plat-omap/Kconfig                 |    5 +++++
 arch/arm/plat-omap/include/plat/multi.h    |    5 +++++
 drivers/tty/serial/Kconfig                 |    2 +-
 11 files changed, 40 insertions(+), 8 deletions(-)

-- 
1.7.5.4

