Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264Ab0LTVwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 16:52:35 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:54087 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980Ab0LTVuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 16:50:03 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas@winischhofer.net
Cc: aaro.koskinen@iki.fi
Subject: [PATCH 02/13] sisfb: delete HAVE_CONFIG_H checks
Date: Mon, 20 Dec 2010 23:50:11 +0200
Message-Id: <1292881822-32630-3-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
References: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unneeded HAVE_CONFIG_H checks.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/init.c    |    4 ----
 drivers/video/sis/init301.c |    4 ----
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/video/sis/init.c b/drivers/video/sis/init.c
index 31137ad..5f49db1 100644
--- a/drivers/video/sis/init.c
+++ b/drivers/video/sis/init.c
@@ -56,10 +56,6 @@
  * Used by permission.
  */
 
-#ifdef HAVE_CONFIG_H
-#include "config.h"
-#endif
-
 #include "init.h"
 
 #ifdef CONFIG_FB_SIS_300
diff --git a/drivers/video/sis/init301.c b/drivers/video/sis/init301.c
index 9fa66fd..e24c5ca 100644
--- a/drivers/video/sis/init301.c
+++ b/drivers/video/sis/init301.c
@@ -57,10 +57,6 @@
  *
  */
 
-#ifdef HAVE_CONFIG_H
-#include "config.h"
-#endif
-
 #if 1
 #define SET_EMI		/* 302LV/ELV: Set EMI values */
 #endif
-- 
1.5.6.5

