Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab1JAUGT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:06:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50081 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756844Ab1JAUFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 19/26] ARM: pxa: CPU_FREQ_TABLE is needed for CPU_FREQ
Date: Sat,  1 Oct 2011 22:03:51 +0200
Message-Id: <1317499438-14058-20-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:4yAKjXm8lHgZ9fi/uO6TzsgWkdel72336TAm8gzRlxQ
 8jSOUMaldVWgOZqFz4Ul5hQWoAO6NH1x5aR9XGkxqMS9r3soY7
 oYorY8kGqaeQjDJKBBIgeBpCcZCtczKVhS/uTzRIcPJZRd1Una
 ASHwEc7FSpwN/U0Me5J4cGTAzDYXFd56Lm1t12klQ/T+P6CQWY
 DBRBdlWkYAZE+NibwctWmm06BPtziyahsWBUi2y7vNl8JkHDWp
 WhhwAx5b4rC9JHcBdGzKnk1Qv1325xUmOGvHttrrPWiD7oWprj
 JZL9/Zyg+PZwzGFaQ7/UZo1pzdfBFeSuUpWZ1ejwYmiHVW7SnV
 4jqdyNyThT/ET4pEzsWbfBK5yO8D3pXQGWhG9EJ7fO0QIXx8O5
 m7QrUUXBz206g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pxa specific cpufreq code is based on the cpu_freq_table
module, so we have to select that.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 71b0ccb..3b84eda 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1926,6 +1926,7 @@ config CPU_FREQ_PXA
 	bool
 	depends on CPU_FREQ && ARCH_PXA && PXA25x
 	default y
+	select CPU_FREQ_TABLE
 	select CPU_FREQ_DEFAULT_GOV_USERSPACE
 
 config CPU_FREQ_S3C
-- 
1.7.5.4

