Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab2BPOoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:44:39 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:43390 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645Ab2BPOoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:44:38 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Colin Cross <ccross@android.com>
Cc: Danny Kukawka <dkukawka@suse.de>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch/arm/mach-tegra/board-dt-tegra20.c: included asm/hardware/gic.h twice
Date: Thu, 16 Feb 2012 15:44:31 +0100
Message-Id: <1329403471-32438-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329403478;75c70ce2;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-tegra/board-dt-tegra20.c: included 'asm/hardware/gic.h'
twice remove the duplicates.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 arch/arm/mach-tegra/board-dt-tegra20.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index 7a95e0b..2a0351b 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -37,7 +37,6 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/time.h>
 #include <asm/setup.h>
-#include <asm/hardware/gic.h>
 
 #include <mach/iomap.h>
 #include <mach/irqs.h>
-- 
1.7.8.3

