Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760372Ab0JZUAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:00:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39462 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758971Ab0JZT53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:57:29 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/22] trivial: fix typos concerning "maintain"
Date: Tue, 26 Oct 2010 21:57:12 +0200
Message-Id: <1288123039-22368-15-git-send-email-u.kleine-koenig@pengutronix.de>
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
 arch/powerpc/platforms/ps3/interrupt.c       |    2 +-
 drivers/media/video/sn9c102/sn9c102_sensor.h |    2 +-
 fs/ocfs2/suballoc.c                          |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/ps3/interrupt.c b/arch/powerpc/platforms/ps3/interrupt.c
index 59d9712..92290ff 100644
--- a/arch/powerpc/platforms/ps3/interrupt.c
+++ b/arch/powerpc/platforms/ps3/interrupt.c
@@ -44,7 +44,7 @@
  * @lock:
  * @ipi_debug_brk_mask:
  *
- * The HV mantains per SMT thread mappings of HV outlet to HV plug on
+ * The HV maintains per SMT thread mappings of HV outlet to HV plug on
  * behalf of the guest.  These mappings are implemented as 256 bit guest
  * supplied bitmaps indexed by plug number.  The addresses of the bitmaps
  * are registered with the HV through lv1_configure_irq_state_bitmap().
diff --git a/drivers/media/video/sn9c102/sn9c102_sensor.h b/drivers/media/video/sn9c102/sn9c102_sensor.h
index 494957b..7f38549 100644
--- a/drivers/media/video/sn9c102/sn9c102_sensor.h
+++ b/drivers/media/video/sn9c102/sn9c102_sensor.h
@@ -147,7 +147,7 @@ enum sn9c102_i2c_interface {
 
 struct sn9c102_sensor {
 	char name[32], /* sensor name */
-	     maintainer[64]; /* name of the mantainer <email> */
+	     maintainer[64]; /* name of the maintainer <email> */
 
 	enum sn9c102_bridge supported_bridge; /* supported SN9C1xx bridges */
 
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 5fed60d..71998d4 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1916,7 +1916,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 	if (res->sr_bg_blkno) {
 		/* Attempt to short-circuit the usual search mechanism
 		 * by jumping straight to the most recently used
-		 * allocation group. This helps us mantain some
+		 * allocation group. This helps us maintain some
 		 * contiguousness across allocations. */
 		status = ocfs2_search_one_group(ac, handle, bits_wanted,
 						min_bits, res, &bits_left);
-- 
1.7.2.3

