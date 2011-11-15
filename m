Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab1KOIqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 03:46:13 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:32841 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753566Ab1KOIqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 03:46:12 -0500
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH/RESEND #3 0/7] SmartReflex Patches
Date: Tue, 15 Nov 2011 10:45:58 +0200
Message-Id: <1321346765-16633-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.8.rc0
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

here's a bunch of patches to smartreflex which have been pending
for months.

Compile tested with omap2plus_defconfig + CONFIG_OMAP_SMARTREFLEX +
CONFIG_OMAP_SMARTREFLEX_CLASS3.

Felipe Balbi (6):
  arm: omap: smartreflex: add missing platform_set_drvdata()
  arm: omap: smartreflex: use dev_get_drvdata()
  arm: omap: smartreflex: move late_initcall() closer to its argument
  arm: omap: smartreflex: clean ups all over
  arm: omap: smartreflex: fix IRQ handling bug
  arm: omap: smartreflex: micro-optimization for sanity check

Nishanth Menon (1):
  OMAP3+: PM: SR: add suspend/resume handlers

 arch/arm/mach-omap2/smartreflex.c |  309 ++++++++++++++++++++++++------------
 1 files changed, 206 insertions(+), 103 deletions(-)

-- 
1.7.8.rc0

