Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab1IWMuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 08:50:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51264 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105Ab1IWMsn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 08:48:43 -0400
thread-index: Acx57w1yGyVmlAakSy+RYvm1mIHd3Q==
Content-Transfer-Encoding: 8BIT
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4657
From: Tero Kristo <t-kristo@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv9 14/18] TEMP: mux: added trace for io wkup event
Date: Fri, 23 Sep 2011 15:46:22 +0300
Message-ID: <1316781986-30642-15-git-send-email-t-kristo@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316781986-30642-1-git-send-email-t-kristo@ti.com>
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Temporary patch for testing purposes, not meant for integration.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 arch/arm/mach-omap2/mux.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index b27c061..642fe3f 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -376,6 +376,8 @@ bool omap_hwmod_mux_get_wake_status(struct omap_hwmod_mux_info *hmux)
 					pad->mux->reg_offset);
 			if (val & OMAP_WAKEUP_EVENT) {
 				ret = true;
+				pr_info("wkup detected: %04x\n",
+					pad->mux->reg_offset);
 				break;
 			}
 		}
-- 
1.7.4.1


Texas Instruments Oy, Tekniikantie 12, 02150 Espoo. Y-tunnus: 0115040-6. Kotipaikka: Helsinki
 

