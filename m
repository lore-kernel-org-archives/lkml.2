Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031838Ab2COQoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:44:34 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56867 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031798Ab2COQo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:44:28 -0400
From: jean.pihet@newoldbits.com
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Jean Pihet <j-pihet@ti.com>
Subject: [PATCH 05/10] ARM: OMAP3: hwmod: rename the smartreflex entries
Date: Thu, 15 Mar 2012 17:44:00 +0100
Message-Id: <1331829845-9526-6-git-send-email-j-pihet@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1331829845-9526-1-git-send-email-j-pihet@ti.com>
References: <1331829845-9526-1-git-send-email-j-pihet@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <j-pihet@ti.com>

Change the name field value to better reflect the smartreflex
integration in the system

Signed-off-by: Jean Pihet <j-pihet@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |    8 ++++----
 arch/arm/mach-omap2/smartreflex.c          |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index 1f681e8..728740d 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -2750,7 +2750,7 @@ static struct omap_hwmod_ocp_if *omap34xx_sr1_slaves[] = {
 };
 
 static struct omap_hwmod omap34xx_sr1_hwmod = {
-	.name		= "sr1",
+	.name		= "mpu_iva",
 	.class		= &omap34xx_smartreflex_hwmod_class,
 	.main_clk	= "sr1_fck",
 	.prcm		= {
@@ -2774,7 +2774,7 @@ static struct omap_hwmod_ocp_if *omap36xx_sr1_slaves[] = {
 };
 
 static struct omap_hwmod omap36xx_sr1_hwmod = {
-	.name		= "sr1",
+	.name		= "mpu_iva",
 	.class		= &omap36xx_smartreflex_hwmod_class,
 	.main_clk	= "sr1_fck",
 	.prcm		= {
@@ -2802,7 +2802,7 @@ static struct omap_hwmod_ocp_if *omap34xx_sr2_slaves[] = {
 };
 
 static struct omap_hwmod omap34xx_sr2_hwmod = {
-	.name		= "sr2",
+	.name		= "core",
 	.class		= &omap34xx_smartreflex_hwmod_class,
 	.main_clk	= "sr2_fck",
 	.prcm		= {
@@ -2826,7 +2826,7 @@ static struct omap_hwmod_ocp_if *omap36xx_sr2_slaves[] = {
 };
 
 static struct omap_hwmod omap36xx_sr2_hwmod = {
-	.name		= "sr2",
+	.name		= "core",
 	.class		= &omap36xx_smartreflex_hwmod_class,
 	.main_clk	= "sr2_fck",
 	.prcm		= {
diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index 8e3ef66..dd80fde 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -184,7 +184,7 @@ static void sr_set_regfields(struct omap_sr *sr)
 		sr->err_weight = OMAP3430_SR_ERRWEIGHT;
 		sr->err_maxlimit = OMAP3430_SR_ERRMAXLIMIT;
 		sr->accum_data = OMAP3430_SR_ACCUMDATA;
-		if (!(strcmp(sr->name, "sr1"))) {
+		if (!(strcmp(sr->name, "sr_mpu_iva"))) {
 			sr->senn_avgweight = OMAP3430_SR1_SENNAVGWEIGHT;
 			sr->senp_avgweight = OMAP3430_SR1_SENPAVGWEIGHT;
 		} else {
-- 
1.7.5.4

