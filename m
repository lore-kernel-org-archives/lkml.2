Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab2IRQgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 12:36:42 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46405 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2IRQg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 12:36:29 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: tony@atomide.com
Cc: linux@arm.linux.org.uk, khilman@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH] arch/arm/mach-omap2: Remove unecessary semicolon
Date: Tue, 18 Sep 2012 18:36:11 +0200
Message-Id: <1347986174-30287-4-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347986174-30287-1-git-send-email-peter.senna@gmail.com>
References: <1347986174-30287-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found by http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 arch/arm/mach-omap2/board-flash.c          | 2 +-
 arch/arm/mach-omap2/clkt_clksel.c          | 2 +-
 arch/arm/mach-omap2/mux.c                  | 2 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c | 6 +++---
 arch/arm/mach-omap2/pm-debug.c             | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap2/board-flash.c b/arch/arm/mach-omap2/board-flash.c
index 53c39d2..d4c5bd5 100644
--- a/arch/arm/mach-omap2/board-flash.c
+++ b/arch/arm/mach-omap2/board-flash.c
@@ -218,7 +218,7 @@ void __init board_flash_init(struct flash_partitions partition_info[],
 			if (onenandcs > GPMC_CS_NUM)
 				onenandcs = cs;
 			break;
-		};
+		}
 		cs++;
 	}
 
diff --git a/arch/arm/mach-omap2/clkt_clksel.c b/arch/arm/mach-omap2/clkt_clksel.c
index 04d551b..fdb79c5 100644
--- a/arch/arm/mach-omap2/clkt_clksel.c
+++ b/arch/arm/mach-omap2/clkt_clksel.c
@@ -365,7 +365,7 @@ void omap2_init_clksel_parent(struct clk *clk)
 						 ((clk->parent) ?
 						  clk->parent->name : "NULL"));
 					clk_reparent(clk, clks->parent);
-				};
+				}
 				found = 1;
 			}
 		}
diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index 9fe6829..701e17c 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -486,7 +486,7 @@ void omap_hwmod_mux(struct omap_hwmod_mux_info *hmux, u8 state)
 		default:
 			/* Nothing to be done */
 			break;
-		};
+		}
 
 		if (val >= 0) {
 			omap_mux_write(pad->partition, val,
diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index ce7e606..5b91454 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -3459,7 +3459,7 @@ int __init omap3xxx_hwmod_init(void)
 	} else {
 		WARN(1, "OMAP3 hwmod family init: unknown chip type\n");
 		return -EINVAL;
-	};
+	}
 
 	r = omap_hwmod_register_links(h);
 	if (r < 0)
@@ -3476,7 +3476,7 @@ int __init omap3xxx_hwmod_init(void)
 		   rev == OMAP3430_REV_ES3_0 || rev == OMAP3430_REV_ES3_1 ||
 		   rev == OMAP3430_REV_ES3_1_2) {
 		h = omap3430es2plus_hwmod_ocp_ifs;
-	};
+	}
 
 	if (h) {
 		r = omap_hwmod_register_links(h);
@@ -3491,7 +3491,7 @@ int __init omap3xxx_hwmod_init(void)
 	} else if (rev == OMAP3430_REV_ES3_0 || rev == OMAP3430_REV_ES3_1 ||
 		   rev == OMAP3430_REV_ES3_1_2) {
 		h = omap3430_es3plus_hwmod_ocp_ifs;
-	};
+	}
 
 	if (h)
 		r = omap_hwmod_register_links(h);
diff --git a/arch/arm/mach-omap2/pm-debug.c b/arch/arm/mach-omap2/pm-debug.c
index 814bcd9..b5acc75 100644
--- a/arch/arm/mach-omap2/pm-debug.c
+++ b/arch/arm/mach-omap2/pm-debug.c
@@ -169,7 +169,7 @@ static int pm_dbg_open(struct inode *inode, struct file *file)
 	default:
 		return single_open(file, pm_dbg_show_timers,
 			&inode->i_private);
-	};
+	}
 }
 
 static const struct file_operations debug_fops = {
-- 
1.7.11.4

