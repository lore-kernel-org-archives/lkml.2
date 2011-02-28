Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab1B1S7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 13:59:34 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:38853 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab1B1S7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 13:59:33 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: arnaud.patard@rtp-net.org, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] staging: xgifb: delete unused module parameter "noaccel"
Date: Mon, 28 Feb 2011 20:59:25 +0200
Message-Id: <1298919565-6061-5-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1298919565-6061-1-git-send-email-aaro.koskinen@iki.fi>
References: <1298919565-6061-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parameter is not used by the driver.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index f2a4a2a..c569d97 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -3435,7 +3435,6 @@ static char *forcecrt2type = NULL;
 static int forcecrt1 = -1;
 static int pdc = -1;
 static int pdc1 = -1;
-static int noaccel = -1;
 static int noypan = -1;
 static int nomax = -1;
 static int userom = -1;
@@ -3456,7 +3455,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("XGITECH , Others");
 
 module_param(mem, int, 0);
-module_param(noaccel, int, 0);
 module_param(noypan, int, 0);
 module_param(nomax, int, 0);
 module_param(userom, int, 0);
@@ -3490,10 +3488,6 @@ MODULE_PARM_DESC(mem,
 		"The value is to be specified without 'KB' and must match the MaxXFBMem setting\n"
 		"for XFree86 4.x/X.org 6.7 and later.\n");
 
-MODULE_PARM_DESC(noaccel,
-		"\nIf set to anything other than 0, 2D acceleration will be disabled.\n"
-		"(default: 0)\n");
-
 MODULE_PARM_DESC(noypan,
 		"\nIf set to anything other than 0, y-panning will be disabled and scrolling\n"
 		"will be performed by redrawing the screen. (default: 0)\n");
-- 
1.5.6.5

