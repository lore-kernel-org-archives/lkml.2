Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab1JAUFk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:05:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61406 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab1JAUFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 18/26] ARM: pxa: MTD_XIP is not actually working any more
Date: Sat,  1 Oct 2011 22:03:50 +0200
Message-Id: <1317499438-14058-19-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:6MAzUvLL4eVJFgvtLko/wsSXRolejNHHZ9AyHJbrB8e
 /fAts7PNPT4DFDStpEpDK/m2SPqvanN92e9NKOePVcnJZq9pwn
 lv86jtJ8uGfQAVbxfsbQY9LDnihGDFTVneUFDe1TIV/3/aykcs
 xKOljBNFOPutWicEQYr2JdOAlnWoLFnkO1MfTFyasuPafYTXes
 VcfjB0WnKjEm5M/2k7PLUoN0iyb1mNnvPm8MaowDs7oZ2phmU2
 wTX2WRKgihddTn44uCWJz08NS8edjwhuoJTrTLKxG3jC8Vokyk
 gY5H/0RqD01/KzMQWNCXr2cuAmcPbOgl/uBbcGjxj6bTNlK5s3
 4IkZuWjMfqewhH12IXKUg7XBrYkGmnrdO/urdLazktv5ODvt+r
 cvoiCJGYe3w5Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The headers files required for XIP support have moved around
over the last few years, and the code no longer builds.
Until someone fixes this, let's just disable support, leaving
sa1100 as the only platform still supporting xip.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 570c9fd..71b0ccb 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -619,7 +619,6 @@ config ARCH_PNX4008
 config ARCH_PXA
 	bool "PXA2xx/PXA3xx-based"
 	depends on MMU
-	select ARCH_MTD_XIP
 	select ARCH_HAS_CPUFREQ
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
-- 
1.7.5.4

