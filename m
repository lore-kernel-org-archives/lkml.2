Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab1I1BID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 21:08:03 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7552 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab1I1BIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 21:08:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 27 Sep 2011 18:07:54 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
Date: Wed, 28 Sep 2011 04:07:47 +0300
Message-ID: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch causes the kernel uncompressor to determine the physical address
of the SDRAM at runtime. This allows the kernel to boot on both tegra20 and
tegra30 even though SDRAM is at different physical addresses on both SoCs.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 472a7f8..474737b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -596,6 +596,7 @@ config ARCH_TEGRA
 	select HAVE_CLK
 	select HAVE_SCHED_CLOCK
 	select ARCH_HAS_CPUFREQ
+	select AUTO_ZRELADDR
 	help
 	  This enables support for NVIDIA Tegra based systems (Tegra APX,
 	  Tegra 6xx and Tegra 2 series).
-- 
1.7.0.4

