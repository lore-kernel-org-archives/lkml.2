Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab1JAUHH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:07:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59223 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab1JAUFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 24/26] ARM: pxa: centro and treo680 need palm27x
Date: Sat,  1 Oct 2011 22:03:56 +0200
Message-Id: <1317499438-14058-25-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:jx7qI/ISYlbaEK9PTh+4xmLiNwU9KM+kyPKBbYSs8V1
 zIPqcpRvMuvWGNg9CP/uDABx02p0Wwgq9GVvkoJ17RkDKFydfR
 1kIp28+OVseVYKJRJRHNHfAc0GAY3AOITtsC7BwkUTZ0sYExjj
 EcyYYj93dCHt7ygjd2rPwr8WIMoIZjPIQcpApYZR1SjZYaUeAw
 PJsuEtG9z4PleFZ3kIKvxvB+nBvw42Q5+KWlIE8wffvV+mHoG6
 rLyt1TiIJOwUc68LNlkgqwOVJuKVeNG187GY+BOvmJdQfSOWXZ
 24fNJfY66OclZxoquvPp+bjgBFfCzuQcE/JIMo7QeZFqBuSlJm
 Q5JP1GRDIlHkSbi7S2r/Q/AoG08Fp+RZu/u6gWl+tlJm/26E9K
 MRb4r42UsnC6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two platforms are part of the palm27x family and use the same
code. Select the palm27x symbol to make sure they can be built
standalone.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-pxa/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index 568b7f6..da6fca0 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -431,6 +431,7 @@ config MACH_CENTRO
 	bool "Palm Centro 685 (GSM)"
 	default y
 	depends on ARCH_PXA_PALM
+	select MACH_PALM27X
 	select PXA27x
 	select IWMMXT
 	select PALM_TREO
@@ -442,6 +443,7 @@ config MACH_TREO680
 	bool "Palm Treo 680"
 	default y
 	depends on ARCH_PXA_PALM
+	select MACH_PALM27X
 	select PXA27x
 	select IWMMXT
 	select PALM_TREO
-- 
1.7.5.4

