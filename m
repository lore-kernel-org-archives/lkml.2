Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab2IKQLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 12:11:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46884 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab2IKQLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 12:11:31 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <j-keerthy@ti.com>, <b-cousson@ti.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 1/4] staging: omap-thermal: Correct checkpatch.pl warnings
Date: Tue, 11 Sep 2012 19:06:52 +0300
Message-ID: <1347379615-6881-2-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1347379615-6881-1-git-send-email-eduardo.valentin@ti.com>
References: <1347379615-6881-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Keerthy <j-keerthy@ti.com>

Removes checkpatch warnings on omap-bandgap.c.

Signed-off-by: J Keerthy <j-keerthy@ti.com>
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index c556abb..9ef44ea 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -1037,20 +1037,20 @@ static int omap_bandgap_save_ctxt(struct omap_bandgap *bg_ptr)
 
 		if (OMAP_BANDGAP_HAS(bg_ptr, MODE_CONFIG))
 			rval->bg_mode_ctrl = omap_bandgap_readl(bg_ptr,
-								tsr->bgap_mode_ctrl);
+							tsr->bgap_mode_ctrl);
 		if (OMAP_BANDGAP_HAS(bg_ptr, COUNTER))
 			rval->bg_counter = omap_bandgap_readl(bg_ptr,
-							      tsr->bgap_counter);
+							tsr->bgap_counter);
 		if (OMAP_BANDGAP_HAS(bg_ptr, TALERT)) {
 			rval->bg_threshold = omap_bandgap_readl(bg_ptr,
-								tsr->bgap_threshold);
+							tsr->bgap_threshold);
 			rval->bg_ctrl = omap_bandgap_readl(bg_ptr,
-							   tsr->bgap_mask_ctrl);
+						   tsr->bgap_mask_ctrl);
 		}
 
 		if (OMAP_BANDGAP_HAS(bg_ptr, TSHUT_CONFIG))
 			rval->tshut_threshold = omap_bandgap_readl(bg_ptr,
-								   tsr->tshut_threshold);
+						   tsr->tshut_threshold);
 	}
 
 	return 0;
@@ -1074,8 +1074,9 @@ static int omap_bandgap_restore_ctxt(struct omap_bandgap *bg_ptr)
 
 		if (val == 0) {
 			if (OMAP_BANDGAP_HAS(bg_ptr, TSHUT_CONFIG))
-				omap_bandgap_writel(bg_ptr, rval->tshut_threshold,
-							   tsr->tshut_threshold);
+				omap_bandgap_writel(bg_ptr,
+					rval->tshut_threshold,
+						   tsr->tshut_threshold);
 			/* Force immediate temperature measurement and update
 			 * of the DTEMP field
 			 */
-- 
1.7.7.1.488.ge8e1c

