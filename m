Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab0IVJww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 05:52:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49027 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab0IVJwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 05:52:51 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, g.liakhovetski@gmx.de, trivial@kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH] ipu_idmac: fixup comment based on color case
Date: Wed, 22 Sep 2010 11:52:30 +0200
Message-Id: <1285149150-12183-1-git-send-email-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/dma/ipu/ipu_idmac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index cb26ee9..e065703 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -321,7 +321,7 @@ static void ipu_ch_param_set_size(union chan_param_mem *params,
 		params->ip.wid2	= 4;		/* Blue bit width - 1 */
 		break;
 	case IPU_PIX_FMT_BGR24:
-		params->ip.bpp	= 1;		/* 24 BPP & RGB PFS */
+		params->ip.bpp	= 1;		/* 24 BPP & BGR PFS */
 		params->ip.pfs	= 4;
 		params->ip.npb	= 7;
 		params->ip.sat	= 2;		/* SAT = 32-bit access */
-- 
1.7.2.3

