Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608Ab2INMGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:06:19 -0400
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:42456 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759507Ab2INMGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:06:13 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v3 10/15] ARM: OMAP4: hwmod_data: Add resource names to McPDM memory ranges
Date: Fri, 14 Sep 2012 15:05:53 +0300
Message-Id: <1347624358-25582-11-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347624358-25582-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347624358-25582-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To help the driver to get the correct memory range to access McPDM
registers.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 242aee4..f65251e 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -5059,6 +5059,7 @@ static struct omap_hwmod_ocp_if omap44xx_l4_per__mcbsp4 = {
 
 static struct omap_hwmod_addr_space omap44xx_mcpdm_addrs[] = {
 	{
+		.name		= "mpu",
 		.pa_start	= 0x40132000,
 		.pa_end		= 0x4013207f,
 		.flags		= ADDR_TYPE_RT
@@ -5077,6 +5078,7 @@ static struct omap_hwmod_ocp_if omap44xx_l4_abe__mcpdm = {
 
 static struct omap_hwmod_addr_space omap44xx_mcpdm_dma_addrs[] = {
 	{
+		.name		= "dma",
 		.pa_start	= 0x49032000,
 		.pa_end		= 0x4903207f,
 		.flags		= ADDR_TYPE_RT
-- 
1.7.12

