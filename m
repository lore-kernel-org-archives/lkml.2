Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0JAC4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 22:56:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46126 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab0JACz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 22:55:28 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <Hiroshi.DOYU@nokia.com>
Cc: <felipe.contreras@nokia.com>, <ameya.palande@nokia.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH 0/4] iovmm: fixes for iovmm module
Date: Thu, 30 Sep 2010 22:08:51 -0500
Message-Id: <1285902536-7043-1-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches are needed in order to tidspbridge can
use iovmm with no issues.

Fernando Guzman Lugo (4):
  iommu: remove CONFIG_MPU_BRIDGE_IOMMU
  iovmm: fix roundup for next area and end check for the last area
  iovmm: add superpages support to fixed da address
  iovmm: replace __iounmap with omap_iounmap

 arch/arm/mach-omap2/omap-iommu.c |    2 -
 arch/arm/plat-omap/iovmm.c       |   69 ++++++++++++++++++++++---------------
 2 files changed, 41 insertions(+), 30 deletions(-)
 mode change 100644 => 100755 arch/arm/plat-omap/iovmm.c

