Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933Ab2EIPLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:11:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62642 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759811Ab2EIPJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:09:37 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 8/9 v3] ASoC: fsi: prepare for conversion to the shdma base library
Date: Wed,  9 May 2012 17:09:20 +0200
Message-Id: <1336576161-27082-9-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:Th5+GJaiMXSGl2L+OY+U8SI5fuc/WgZGHvJucoXh+yS
 tP/lkZJjgjTvMWmNIaPUd30GHS7zyZvBoOAJZqgqDVma6CiPZ0
 rb9ZjN913LGWUpsZTayEivMv4KGU2oXbBSudkR752NJ0jH7pVZ
 P57vtTS9VyEXXzET+RDMnowzChZZ6euJ8eaGW/hKjLqhPKh77E
 XvNSLMB/WSpQeo3g0YpPqdWo5ZRq1+kXN5Xf5WV5Kr5KNtDAHR
 E/yKWeHwFkpcCB/HeWMlD95ZNDIkdGSMKNELsRJSTlWHfeFUib
 xjXteBizBcr8ERugjTrglKHSMSMmIcS6gsKvN2xeZDEHiyOQPb
 Lvq/KshmUn3123nEWHWB6ZcdKtV4dS90jGF9grP6S7oZ2P0SDF
 fDBnhK+a4wa6Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 sound/soc/sh/fsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sh/fsi.c b/sound/soc/sh/fsi.c
index 74ed2df..c28314b 100644
--- a/sound/soc/sh/fsi.c
+++ b/sound/soc/sh/fsi.c
@@ -1532,8 +1532,8 @@ static void fsi_handler_init(struct fsi_priv *fsi)
 	fsi->capture.priv	= fsi;
 
 	if (fsi->info->tx_id) {
-		fsi->playback.slave.slave_id	= fsi->info->tx_id;
-		fsi->playback.handler		= &fsi_dma_push_handler;
+		fsi->playback.slave.shdma_slave.slave_id = fsi->info->tx_id;
+		fsi->playback.handler = &fsi_dma_push_handler;
 	}
 }
 
-- 
1.7.2.5

