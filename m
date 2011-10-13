Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab1JMOMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:12:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:38698 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517Ab1JMOLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:11:04 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linuxppc-dev@ozlabs.org
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
        alexandre.bounine@idt.com, Kai Jiang <Kai.Jiang@freescale.com>
Subject: [PATCH 5/5][v2] powerpc/8xxx: Update device tree bus probe for new RapidIO node binding
Date: Thu, 13 Oct 2011 09:08:42 -0500
Message-Id: <1318514922-12672-5-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1318514922-12672-4-git-send-email-galak@kernel.crashing.org>
References: <1318514922-12672-1-git-send-email-galak@kernel.crashing.org>
 <1318514922-12672-2-git-send-email-galak@kernel.crashing.org>
 <1318514922-12672-3-git-send-email-galak@kernel.crashing.org>
 <1318514922-12672-4-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kai Jiang <Kai.Jiang@freescale.com>

Update of_platform_bus_probe() RapidIO node to be compitable with
new RapidIO dts compatible property.

Signed-off-by: Kai Jiang <Kai.Jiang@freescale.com>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 arch/powerpc/platforms/85xx/corenet_ds.c   |    2 +-
 arch/powerpc/platforms/85xx/mpc85xx_mds.c  |    2 +-
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/85xx/corenet_ds.c b/arch/powerpc/platforms/85xx/corenet_ds.c
index 802ad11..c48b661 100644
--- a/arch/powerpc/platforms/85xx/corenet_ds.c
+++ b/arch/powerpc/platforms/85xx/corenet_ds.c
@@ -112,7 +112,7 @@ static const struct of_device_id of_device_ids[] __devinitconst = {
 		.compatible	= "simple-bus"
 	},
 	{
-		.compatible	= "fsl,rapidio-delta",
+		.compatible	= "fsl,srio",
 	},
 	{
 		.compatible	= "fsl,p4080-pcie",
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
index a23a3ff..7968ced 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
@@ -433,7 +433,7 @@ static struct of_device_id mpc85xx_ids[] = {
 	{ .compatible = "soc", },
 	{ .compatible = "simple-bus", },
 	{ .compatible = "gianfar", },
-	{ .compatible = "fsl,rapidio-delta", },
+	{ .compatible = "fsl,srio", },
 	{ .compatible = "fsl,mpc8548-guts", },
 	{ .compatible = "gpio-leds", },
 	{},
diff --git a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
index b11c353..569262c 100644
--- a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
+++ b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
@@ -161,7 +161,7 @@ mpc86xx_time_init(void)
 
 static __initdata struct of_device_id of_bus_ids[] = {
 	{ .compatible = "simple-bus", },
-	{ .compatible = "fsl,rapidio-delta", },
+	{ .compatible = "fsl,srio", },
 	{ .compatible = "gianfar", },
 	{},
 };
-- 
1.7.3.4

