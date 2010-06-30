Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab0F3Pyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:54:46 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:39505 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754015Ab0F3Pyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:54:44 -0400
Date: Wed, 30 Jun 2010 17:54:42 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
       Cory Maccarrone <darkstar6262@gmail.com>,
       "Zebediah C. McClure" <zmc@lurian.net>,
       Alistair Buxton <a.j.buxton@gmail.com>, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 03/33] Removing dead OMAP_MUX_ERRORS
Message-ID: <b6ca168f9459162f2c96aa8ef999047a3c4f6f9c.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP_MUX_ERRORS doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-omap1/mux.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap1/mux.c b/arch/arm/mach-omap1/mux.c
index 8434137..1ddb02c 100644
--- a/arch/arm/mach-omap1/mux.c
+++ b/arch/arm/mach-omap1/mux.c
@@ -439,12 +439,7 @@ int __init_or_module omap1_cfg_reg(const struct pin_config *cfg)
 			       cfg->pull_name, cfg->pull_reg, pull_orig, pull);
 	}
 #endif
-
-#ifdef CONFIG_OMAP_MUX_ERRORS
-	return warn ? -ETXTBSY : 0;
-#else
 	return 0;
-#endif
 }
 
 int __init omap1_mux_init(void)
-- 
1.7.0.4

