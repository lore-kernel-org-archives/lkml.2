Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab1DMJ53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 05:57:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48626 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754878Ab1DMJ51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 05:57:27 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 2/5] gma500: prepare to do some actual memory management
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 13 Apr 2011 10:35:50 +0100
Message-ID: <20110413093546.28527.84724.stgit@localhost.localdomain>
In-Reply-To: <20110413093519.28527.36552.stgit@localhost.localdomain>
References: <20110413093519.28527.36552.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drv.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index df50553..d87e00d 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -1425,12 +1425,8 @@ static struct drm_driver driver = {
 	.lastclose = psb_lastclose,
 	.open = psb_driver_open,
 	.postclose = psb_driver_close,
-#if 0	/* ACFIXME */
-	.get_map_ofs = drm_core_get_map_ofs,
-	.get_reg_ofs = drm_core_get_reg_ofs,
-	.proc_init = psb_proc_init,
-	.proc_cleanup = psb_proc_cleanup,
-#endif
+	.reclaim_buffers = drm_core_reclaim_buffers,
+
 	.preclose = psb_driver_preclose,
 	.fops = {
 		 .owner = THIS_MODULE,

