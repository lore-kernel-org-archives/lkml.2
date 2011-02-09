Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab1BIKIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:08:06 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46675 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab1BIKIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:08:02 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] trivial: fix typos concerning "initiali[zs]e"
Date: Wed,  9 Feb 2011 11:07:40 +0100
Message-Id: <1297246062-23777-8-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297246062-23777-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1297246062-23777-1-git-send-email-u.kleine-koenig@pengutronix.de>
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
 arch/arm/mach-omap2/voltage.c     |    2 +-
 drivers/gpu/drm/radeon/atombios.h |    4 ++--
 drivers/media/video/ir-kbd-i2c.c  |    2 +-
 drivers/mmc/host/msm_sdcc.c       |    2 +-
 drivers/net/bnx2x/bnx2x_cmn.h     |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/voltage.c b/arch/arm/mach-omap2/voltage.c
index ed6079c..01a2261 100644
--- a/arch/arm/mach-omap2/voltage.c
+++ b/arch/arm/mach-omap2/voltage.c
@@ -730,7 +730,7 @@ static int vp_forceupdate_scale_voltage(struct omap_vdd_info *vdd,
 /* OMAP3 specific voltage init functions */
 
 /*
- * Intializes the voltage controller registers with the PMIC and board
+ * Initializes the voltage controller registers with the PMIC and board
  * specific parameters and voltage setup times for OMAP3.
  */
 static void __init omap3_vc_init(struct omap_vdd_info *vdd)
diff --git a/drivers/gpu/drm/radeon/atombios.h b/drivers/gpu/drm/radeon/atombios.h
index 04b269d..892e580 100644
--- a/drivers/gpu/drm/radeon/atombios.h
+++ b/drivers/gpu/drm/radeon/atombios.h
@@ -6770,9 +6770,9 @@ typedef struct _ATOM_PPLIB_SUMO_CLOCK_INFO{
       UCHAR  ucEngineClockHigh; //clockfrequency >> 16. 
       UCHAR  vddcIndex;         //2-bit vddc index;
       UCHAR  leakage;          //please use 8-bit absolute value, not the 6-bit % value 
-      //please initalize to 0
+      //please initialize to 0
       UCHAR  rsv;
-      //please initalize to 0
+      //please initialize to 0
       USHORT rsv1;
       //please initialize to 0s
       ULONG rsv2[2];
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index a221ad6..081716b 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -387,7 +387,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	if (!rc) {
 		/*
-		 * If platform_data doesn't specify rc_dev, initilize it
+		 * If platform_data doesn't specify rc_dev, initialize it
 		 * internally
 		 */
 		rc = rc_allocate_device();
diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 153ab97..d097654 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -148,7 +148,7 @@ static void msmsdcc_reset_and_restore(struct msmsdcc_host *host)
 		pr_err("%s: Clock deassert failed at %u Hz with err %d\n",
 				mmc_hostname(host->mmc), host->clk_rate, ret);
 
-	pr_info("%s: Controller has been re-initialiazed\n",
+	pr_info("%s: Controller has been re-initialized\n",
 			mmc_hostname(host->mmc));
 
 	/* Restore the contoller state */
diff --git a/drivers/net/bnx2x/bnx2x_cmn.h b/drivers/net/bnx2x/bnx2x_cmn.h
index 03eb4d6..a145913 100644
--- a/drivers/net/bnx2x/bnx2x_cmn.h
+++ b/drivers/net/bnx2x/bnx2x_cmn.h
@@ -324,7 +324,7 @@ int bnx2x_func_start(struct bnx2x *bp);
 void bnx2x_ilt_set_info(struct bnx2x *bp);
 
 /**
- * Inintialize dcbx protocol
+ * Initialize dcbx protocol
  *
  * @param bp
  */
-- 
1.7.2.3

