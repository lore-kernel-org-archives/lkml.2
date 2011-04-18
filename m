Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab1DRTTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:19:52 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:37391 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab1DRTTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:19:50 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Apr 2011 15:19:50 EDT
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 12/12] staging: xgifb: main: make internal functions static
Date: Mon, 18 Apr 2011 22:14:08 +0300
Message-Id: <1303154048-21989-13-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
References: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make remaining non-static internal functions static.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 3cffc20..c0b2c7a 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -388,7 +388,7 @@ static void XGIRegInit(struct vb_device_info *XGI_Pr, unsigned long BaseAddr)
 
 /* ------------ Interface for init & mode switching code ------------- */
 
-unsigned char XGIfb_query_VGA_config_space(
+static unsigned char XGIfb_query_VGA_config_space(
 		struct xgi_hw_device_info *pXGIhw_ext, unsigned long offset,
 		unsigned long set, unsigned long *value)
 {
@@ -426,7 +426,7 @@ unsigned char XGIfb_query_VGA_config_space(
 
 /* ------------------ Internal helper routines ----------------- */
 
-int XGIfb_GetXG21DefaultLVDSModeIdx(void)
+static int XGIfb_GetXG21DefaultLVDSModeIdx(void)
 {
 
 	int found_mode = 0;
-- 
1.5.6.5

