Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab1CHUQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:16:18 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:42461 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299Ab1CHUQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:16:13 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 07/15] staging: xgifb: delete nomax module parameter
Date: Tue,  8 Mar 2011 22:16:12 +0200
Message-Id: <1299615380-22922-8-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parameter is not used.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index ce569af..ee80171 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2707,7 +2707,6 @@ static int forcecrt1 = -1;
 static int pdc = -1;
 static int pdc1 = -1;
 static int noypan = -1;
-static int nomax = -1;
 static int userom = -1;
 static int useoem = -1;
 static char *tvstandard = NULL;
@@ -2727,7 +2726,6 @@ MODULE_AUTHOR("XGITECH , Others");
 
 module_param(mem, int, 0);
 module_param(noypan, int, 0);
-module_param(nomax, int, 0);
 module_param(userom, int, 0);
 module_param(useoem, int, 0);
 module_param(mode, charp, 0);
@@ -2754,13 +2752,6 @@ MODULE_PARM_DESC(noypan,
 		"\nIf set to anything other than 0, y-panning will be disabled and scrolling\n"
 		"will be performed by redrawing the screen. (default: 0)\n");
 
-MODULE_PARM_DESC(nomax,
-		"\nIf y-panning is enabled, xgifb will by default use the entire available video\n"
-		"memory for the virtual screen in order to optimize scrolling performance. If\n"
-		"this is set to anything other than 0, xgifb will not do this and thereby\n"
-		"enable the user to positively specify a virtual Y size of the screen using\n"
-		"fbset. (default: 0)\n");
-
 MODULE_PARM_DESC(mode,
 		"\nSelects the desired default display mode in the format XxYxDepth,\n"
 		"eg. 1024x768x16. Other formats supported include XxY-Depth and\n"
-- 
1.5.6.5

