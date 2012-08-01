Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab2HARvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 13:51:15 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39570 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab2HARu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 13:50:28 -0400
From: Matt Sealey <matt@genesi-usa.com>
To: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Sealey <matt@genesi-usa.com>
Subject: [PATCH 2/4] efikamx: remove Genesi Efika MX from the i.MX v6/v7 defconfig
Date: Wed,  1 Aug 2012 12:49:29 -0500
Message-Id: <1343843371-14143-3-git-send-email-matt@genesi-usa.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343843371-14143-1-git-send-email-matt@genesi-usa.com>
References: <1343843371-14143-1-git-send-email-matt@genesi-usa.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to have Efika MX listed in the defconfig if it can't be built.

Signed-off-by: Matt Sealey <matt@genesi-usa.com>
---
 arch/arm/configs/imx_v6_v7_defconfig |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index b1d3675..0becdbe 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -31,8 +31,6 @@ CONFIG_MACH_IMX51_DT=y
 CONFIG_MACH_MX51_3DS=y
 CONFIG_MACH_EUKREA_CPUIMX51=y
 CONFIG_MACH_EUKREA_CPUIMX51SD=y
-CONFIG_MACH_MX51_EFIKAMX=y
-CONFIG_MACH_MX51_EFIKASB=y
 CONFIG_MACH_IMX53_DT=y
 CONFIG_SOC_IMX6Q=y
 CONFIG_MXC_PWM=y
-- 
1.7.9.5

