Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab0IVJxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 05:53:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49036 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab0IVJxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 05:53:53 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: g.liakhovetski@gmx.de
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH] mx3fb: fixup sort order of color bitwidth
Date: Wed, 22 Sep 2010 11:53:43 +0200
Message-Id: <1285149223-1301-1-git-send-email-m.grzeschik@pengutronix.de>
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
 drivers/video/mx3fb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index 7cfc170..658f10a 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -660,12 +660,12 @@ static uint32_t bpp_to_pixfmt(int bpp)
 {
 	uint32_t pixfmt = 0;
 	switch (bpp) {
-	case 24:
-		pixfmt = IPU_PIX_FMT_BGR24;
-		break;
 	case 32:
 		pixfmt = IPU_PIX_FMT_BGR32;
 		break;
+	case 24:
+		pixfmt = IPU_PIX_FMT_BGR24;
+		break;
 	case 16:
 		pixfmt = IPU_PIX_FMT_RGB565;
 		break;
-- 
1.7.2.3

