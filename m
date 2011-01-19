Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab1ASIUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 03:20:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50085 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab1ASITj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 03:19:39 -0500
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Morsing <daniel.morsing@gmail.com>, charu@ti.com,
        sshtylyov@mvista.com
Subject: [PATCHv4 4/4] OMAP3: Devkit8000: Fix indentation of brace
Date: Wed, 19 Jan 2011 09:19:26 +0100
Message-Id: <1295425166-25540-5-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295425166-25540-1-git-send-email-weber@corscience.de>
References: <1295425166-25540-1-git-send-email-weber@corscience.de>
X-Provags-ID: V02:K0:J9Bf9ecbzGl0kVR9Vp43zp3Mfbhe+f2SjYlFm7hx21E
 UeBqLs47pDpv0HB30jHR5wp6FPUhw5VyfGDFTbKKDR4Ro5KZ6U
 F4QSyvR92Oyskx5X0ccW9lEstnXci4GZTO7RWeDUxAXFX7CoFm
 m+/Jq/1Pz/Az4tL5iPg8vfKiZ0Xd5PvXKsGoYCq8VERRXH1Ubx
 oAsYGhgPv1uHE8+vqWijQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix indentation of a closing curly brace.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 arch/arm/mach-omap2/board-devkit8000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 4ddd81c..a344cd8 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -553,7 +553,7 @@ static void __init omap_dm9000_init(void)
 		printk(KERN_ERR "Failed to request GPIO%d for dm9000 IRQ\n",
 			OMAP_DM9000_GPIO_IRQ);
 		return;
-		}
+	}
 
 	gpio_direction_input(OMAP_DM9000_GPIO_IRQ);
 
-- 
1.7.4.rc2

