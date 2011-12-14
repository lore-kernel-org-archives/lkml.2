Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab1LNPa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:30:28 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38068 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab1LNPaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:30:25 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>, shawn.guo@freescale.com,
        Kukjin Kim <kgene.kim@samsung.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>, Barry Song <baohua.song@csr.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 6/9] ARM: realview: convert pl061 no irq to 0 instead of -1
Date: Wed, 14 Dec 2011 09:28:55 -0600
Message-Id: <1323876538-20406-7-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323876538-20406-1-git-send-email-robherring2@gmail.com>
References: <1323876538-20406-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Drivers should use 0 for no irq, so convert realview platforms pl061
platform_data over to use 0.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/mach-realview/realview_eb.c     |    3 ---
 arch/arm/mach-realview/realview_pb1176.c |    3 ---
 arch/arm/mach-realview/realview_pb11mp.c |    3 ---
 arch/arm/mach-realview/realview_pba8.c   |    3 ---
 arch/arm/mach-realview/realview_pbx.c    |    3 ---
 5 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-realview/realview_eb.c b/arch/arm/mach-realview/realview_eb.c
index 026c66a..57f5bac 100644
--- a/arch/arm/mach-realview/realview_eb.c
+++ b/arch/arm/mach-realview/realview_eb.c
@@ -117,17 +117,14 @@ static void __init realview_eb_map_io(void)
 
 static struct pl061_platform_data gpio0_plat_data = {
 	.gpio_base	= 0,
-	.irq_base	= -1,
 };
 
 static struct pl061_platform_data gpio1_plat_data = {
 	.gpio_base	= 8,
-	.irq_base	= -1,
 };
 
 static struct pl061_platform_data gpio2_plat_data = {
 	.gpio_base	= 16,
-	.irq_base	= -1,
 };
 
 static struct pl022_ssp_controller ssp0_plat_data = {
diff --git a/arch/arm/mach-realview/realview_pb1176.c b/arch/arm/mach-realview/realview_pb1176.c
index c057540..2267696 100644
--- a/arch/arm/mach-realview/realview_pb1176.c
+++ b/arch/arm/mach-realview/realview_pb1176.c
@@ -113,17 +113,14 @@ static void __init realview_pb1176_map_io(void)
 
 static struct pl061_platform_data gpio0_plat_data = {
 	.gpio_base	= 0,
-	.irq_base	= -1,
 };
 
 static struct pl061_platform_data gpio1_plat_data = {
 	.gpio_base	= 8,
-	.irq_base	= -1,
 };
 
 static struct pl061_platform_data gpio2_plat_data = {
 	.gpio_base	= 16,
-	.irq_base	= -1,
 };
 
 static struct pl022_ssp_controller ssp0_plat_data = {
diff --git a/arch/arm/mach-realview/realview_pb11mp.c b/arch/arm/mach-realview/realview_pb11mp.c
index 671ad6d..8622dbb 100644
--- a/arch/arm/mach-realview/realview_pb11mp.c
+++ b/arch/arm/mach-realview/realview_pb11mp.c
@@ -112,17 +112,14 @@ static void __init realview_pb11mp_map_io(void)
 
 static struct pl061_platform_data gpio0_plat_data = {
 	.gpio_base	= 0,
-	.irq_base	= -1,
 };
 
 static struct pl061_platform_data gpio1_plat_data = {
 	.gpio_base	= 8,
-	.irq_base	= -1,
 };
 
 static struct pl061_platform_data gpio2_plat_data = {
 	.gpio_base	= 16,
-	.irq_base	= -1,
 };
 
 static struct pl022_ssp_controller ssp0_plat_data = {
diff --git a/arch/arm/mach-realview/realview_pba8.c b/arch/arm/mach-realview/realview_pba8.c
index cbf22df..6f9511d 100644
--- a/arch/arm/mach-realview/realview_pba8.c
+++ b/arch/arm/mach-realview/realview_pba8.c
@@ -102,17 +102,14 @@ static void __init realview_pba8_map_io(void)
 
 static struct pl061_platform_data gpio0_plat_data = {
 	.gpio_base	= 0,
-	.irq_base	= -1,
 };
 
 static struct pl061_platform_data gpio1_plat_data = {
 	.gpio_base	= 8,
-	.irq_base	= -1,
 };
 
 static struct pl061_platform_data gpio2_plat_data = {
 	.gpio_base	= 16,
-	.irq_base	= -1,
 };
 
 static struct pl022_ssp_controller ssp0_plat_data = {
diff --git a/arch/arm/mach-realview/realview_pbx.c b/arch/arm/mach-realview/realview_pbx.c
index 63c4114..be3a01f 100644
--- a/arch/arm/mach-realview/realview_pbx.c
+++ b/arch/arm/mach-realview/realview_pbx.c
@@ -124,17 +124,14 @@ static void __init realview_pbx_map_io(void)
 
 static struct pl061_platform_data gpio0_plat_data = {
 	.gpio_base	= 0,
-	.irq_base	= -1,
 };
 
 static struct pl061_platform_data gpio1_plat_data = {
 	.gpio_base	= 8,
-	.irq_base	= -1,
 };
 
 static struct pl061_platform_data gpio2_plat_data = {
 	.gpio_base	= 16,
-	.irq_base	= -1,
 };
 
 static struct pl022_ssp_controller ssp0_plat_data = {
-- 
1.7.5.4

