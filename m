Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270Ab0JZT5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:57:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39476 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab0JZT5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:57:37 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/22] trivial: fix typos concerning "hierarchy"
Date: Tue, 26 Oct 2010 21:57:08 +0200
Message-Id: <1288123039-22368-11-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 sound/soc/s3c24xx/smdk_spdif.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/s3c24xx/smdk_spdif.c b/sound/soc/s3c24xx/smdk_spdif.c
index f31d22a..11c88b1 100644
--- a/sound/soc/s3c24xx/smdk_spdif.c
+++ b/sound/soc/s3c24xx/smdk_spdif.c
@@ -61,7 +61,7 @@ static int set_audio_clock_heirachy(struct platform_device *pdev)
 		goto out3;
 	}
 
-	/* Set audio clock heirachy for S/PDIF */
+	/* Set audio clock hierarchy for S/PDIF */
 	clk_set_parent(mout_epll, fout_epll);
 	clk_set_parent(sclk_audio0, mout_epll);
 	clk_set_parent(sclk_spdif, sclk_audio0);
@@ -79,7 +79,7 @@ out1:
 
 /* We should haved to set clock directly on this part because of clock
  * scheme of Samsudng SoCs did not support to set rates from abstrct
- * clock of it's heirachy.
+ * clock of it's hierarchy.
  */
 static int set_audio_clock_rate(unsigned long epll_rate,
 				unsigned long audio_rate)
@@ -197,7 +197,7 @@ static int __init smdk_init(void)
 	if (ret)
 		goto err1;
 
-	/* Set audio clock heirachy manually */
+	/* Set audio clock hierarchy manually */
 	ret = set_audio_clock_heirachy(smdk_snd_spdif_device);
 	if (ret)
 		goto err1;
-- 
1.7.2.3

