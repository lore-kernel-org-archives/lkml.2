Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab1KLMCz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 07:02:55 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:22879
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769Ab1KLMCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 07:02:54 -0500
X-SpamScore: 3
X-BigFish: VS3(z37d5kzzz1202hzz8275bh8275dhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,13,
From: Liu Gang <Gang.Liu@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <Alexandre.Bounine@idt.com>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>, <B11780@freescale.com>, <r61911@freescale.com>,
        Kai Jiang <Kai.Jiang@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: [PATCH 4/5,v3] powerpc/8xxx: Update device tree bus probe for new RapidIO node binding
Date: Sat, 12 Nov 2011 20:02:31 +0800
Message-ID: <1321099352-21462-4-git-send-email-Gang.Liu@freescale.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1321099352-21462-1-git-send-email-Gang.Liu@freescale.com>
References: <1321099352-21462-1-git-send-email-Gang.Liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.net
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
1.7.3.1


