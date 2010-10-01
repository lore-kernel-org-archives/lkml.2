Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab0JAL7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:59:36 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:37959 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932246Ab0JAL7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:59:32 -0400
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Ryan Mallon <ryan@bluewatersys.com>, shiraz.hashim@st.com,
        vipin.kumar@st.com, deepak.sikri@st.com, armando.visconti@st.com,
        vipulkumar.samar@st.com, rajeev-dlh.kumar@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 57/69] SPEAr3xx: Make local structures static
Date: Fri,  1 Oct 2010 17:26:17 +0530
Message-Id: <a4419b75d9a8f793c745d89e1cd0ba5d23880bd1.1285933332.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryan Mallon <ryan@bluewatersys.com>

Several structures in arch/arm/mach-spear3xx are not marked static
like they should be. Fix this.

Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/mach-spear3xx/spear300.c |    6 +++---
 arch/arm/mach-spear3xx/spear310.c |   16 ++++++++--------
 arch/arm/mach-spear3xx/spear320.c |   12 ++++++------
 arch/arm/mach-spear3xx/spear3xx.c |    2 --
 4 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-spear3xx/spear300.c b/arch/arm/mach-spear3xx/spear300.c
index 9885fe9..bbaf872 100644
--- a/arch/arm/mach-spear3xx/spear300.c
+++ b/arch/arm/mach-spear3xx/spear300.c
@@ -114,7 +114,6 @@ struct pmx_mode caml_lcd_mode = {
 	.value = 0x0F,
 };
 
-/* devices */
 /* Pad multiplexing for FSMC 2 NAND devices */
 static struct pmx_mux_reg pmx_fsmc_2_mux[] = {
 	{
@@ -700,7 +699,7 @@ struct platform_device sdhci_device = {
 };
 
 /* spear3xx shared irq */
-struct shirq_dev_config shirq_ras1_config[] = {
+static struct shirq_dev_config shirq_ras1_config[] = {
 	{
 		.virq = VIRQ_IT_PERS_S,
 		.enb_mask = IT_PERS_S_IRQ_MASK,
@@ -740,7 +739,8 @@ struct shirq_dev_config shirq_ras1_config[] = {
 	},
 };
 
-struct spear_shirq shirq_ras1 = {
+
+static struct spear_shirq shirq_ras1 = {
 	.irq = IRQ_GEN_RAS_1,
 	.dev_config = shirq_ras1_config,
 	.dev_count = ARRAY_SIZE(shirq_ras1_config),
diff --git a/arch/arm/mach-spear3xx/spear310.c b/arch/arm/mach-spear3xx/spear310.c
index be2f9de..7d4ff0e 100644
--- a/arch/arm/mach-spear3xx/spear310.c
+++ b/arch/arm/mach-spear3xx/spear310.c
@@ -363,7 +363,7 @@ struct platform_device plgpio_device = {
 
 
 /* spear3xx shared irq */
-struct shirq_dev_config shirq_ras1_config[] = {
+static struct shirq_dev_config shirq_ras1_config[] = {
 	{
 		.virq = VIRQ_SMII0,
 		.status_mask = SMII0_IRQ_MASK,
@@ -391,7 +391,7 @@ struct shirq_dev_config shirq_ras1_config[] = {
 	},
 };
 
-struct spear_shirq shirq_ras1 = {
+static struct spear_shirq shirq_ras1 = {
 	.irq = IRQ_GEN_RAS_1,
 	.dev_config = shirq_ras1_config,
 	.dev_count = ARRAY_SIZE(shirq_ras1_config),
@@ -403,7 +403,7 @@ struct spear_shirq shirq_ras1 = {
 	},
 };
 
-struct shirq_dev_config shirq_ras2_config[] = {
+static struct shirq_dev_config shirq_ras2_config[] = {
 	{
 		.virq = VIRQ_UART1,
 		.status_mask = UART1_IRQ_MASK,
@@ -422,7 +422,7 @@ struct shirq_dev_config shirq_ras2_config[] = {
 	},
 };
 
-struct spear_shirq shirq_ras2 = {
+static struct spear_shirq shirq_ras2 = {
 	.irq = IRQ_GEN_RAS_2,
 	.dev_config = shirq_ras2_config,
 	.dev_count = ARRAY_SIZE(shirq_ras2_config),
@@ -434,14 +434,14 @@ struct spear_shirq shirq_ras2 = {
 	},
 };
 
-struct shirq_dev_config shirq_ras3_config[] = {
+static struct shirq_dev_config shirq_ras3_config[] = {
 	{
 		.virq = VIRQ_EMI,
 		.status_mask = EMI_IRQ_MASK,
 	},
 };
 
-struct spear_shirq shirq_ras3 = {
+static struct spear_shirq shirq_ras3 = {
 	.irq = IRQ_GEN_RAS_3,
 	.dev_config = shirq_ras3_config,
 	.dev_count = ARRAY_SIZE(shirq_ras3_config),
@@ -453,7 +453,7 @@ struct spear_shirq shirq_ras3 = {
 	},
 };
 
-struct shirq_dev_config shirq_intrcomm_ras_config[] = {
+static struct shirq_dev_config shirq_intrcomm_ras_config[] = {
 	{
 		.virq = VIRQ_TDM_HDLC,
 		.status_mask = TDM_HDLC_IRQ_MASK,
@@ -466,7 +466,7 @@ struct shirq_dev_config shirq_intrcomm_ras_config[] = {
 	},
 };
 
-struct spear_shirq shirq_intrcomm_ras = {
+static struct spear_shirq shirq_intrcomm_ras = {
 	.irq = IRQ_INTRCOMM_RAS_ARM,
 	.dev_config = shirq_intrcomm_ras_config,
 	.dev_count = ARRAY_SIZE(shirq_intrcomm_ras_config),
diff --git a/arch/arm/mach-spear3xx/spear320.c b/arch/arm/mach-spear3xx/spear320.c
index bd308b8..948ca8e 100644
--- a/arch/arm/mach-spear3xx/spear320.c
+++ b/arch/arm/mach-spear3xx/spear320.c
@@ -835,7 +835,7 @@ struct platform_device sdhci_device = {
 };
 
 /* spear3xx shared irq */
-struct shirq_dev_config shirq_ras1_config[] = {
+static struct shirq_dev_config shirq_ras1_config[] = {
 	{
 		.virq = VIRQ_EMI,
 		.status_mask = EMI_IRQ_MASK,
@@ -851,7 +851,7 @@ struct shirq_dev_config shirq_ras1_config[] = {
 	},
 };
 
-struct spear_shirq shirq_ras1 = {
+static struct spear_shirq shirq_ras1 = {
 	.irq = IRQ_GEN_RAS_1,
 	.dev_config = shirq_ras1_config,
 	.dev_count = ARRAY_SIZE(shirq_ras1_config),
@@ -864,7 +864,7 @@ struct spear_shirq shirq_ras1 = {
 	},
 };
 
-struct shirq_dev_config shirq_ras3_config[] = {
+static struct shirq_dev_config shirq_ras3_config[] = {
 	{
 		.virq = VIRQ_PLGPIO,
 		.enb_mask = GPIO_IRQ_MASK,
@@ -883,7 +883,7 @@ struct shirq_dev_config shirq_ras3_config[] = {
 	},
 };
 
-struct spear_shirq shirq_ras3 = {
+static struct spear_shirq shirq_ras3 = {
 	.irq = IRQ_GEN_RAS_3,
 	.dev_config = shirq_ras3_config,
 	.dev_count = ARRAY_SIZE(shirq_ras3_config),
@@ -897,7 +897,7 @@ struct spear_shirq shirq_ras3 = {
 	},
 };
 
-struct shirq_dev_config shirq_intrcomm_ras_config[] = {
+static struct shirq_dev_config shirq_intrcomm_ras_config[] = {
 	{
 		.virq = VIRQ_CANU,
 		.status_mask = CAN_U_IRQ_MASK,
@@ -945,7 +945,7 @@ struct shirq_dev_config shirq_intrcomm_ras_config[] = {
 	},
 };
 
-struct spear_shirq shirq_intrcomm_ras = {
+static struct spear_shirq shirq_intrcomm_ras = {
 	.irq = IRQ_INTRCOMM_RAS_ARM,
 	.dev_config = shirq_intrcomm_ras_config,
 	.dev_count = ARRAY_SIZE(shirq_intrcomm_ras_config),
diff --git a/arch/arm/mach-spear3xx/spear3xx.c b/arch/arm/mach-spear3xx/spear3xx.c
index ec1340c..544072d 100644
--- a/arch/arm/mach-spear3xx/spear3xx.c
+++ b/arch/arm/mach-spear3xx/spear3xx.c
@@ -292,7 +292,6 @@ void __init spear3xx_map_io(void)
 }
 
 /* pad multiplexing support */
-/* devices */
 
 /* Pad multiplexing for firda device */
 static struct pmx_mux_reg pmx_firda_mux[] = {
@@ -625,7 +624,6 @@ struct pmx_dev pmx_timer_1_2 = {
 };
 
 #if defined(CONFIG_MACH_SPEAR310) || defined(CONFIG_MACH_SPEAR320)
-/* plgpios devices */
 /* Pad multiplexing for plgpio_0_1 devices */
 static struct pmx_mux_reg pmx_plgpio_0_1_mux[] = {
 	{
-- 
1.7.2.2

