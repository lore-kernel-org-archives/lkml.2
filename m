Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030219Ab2GFKmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:42:33 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:46829 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964812Ab2GFKlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:41:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAHC/9k9bdWOb/2dsb2JhbABFhWSxVIEHghkBBSMECwFGECUCJgICVwcSiA+nOZMDgSCPLYESA5U3kAOCYQ
X-IronPort-AV: E=Sophos;i="4.77,537,1336341600"; 
   d="scan'208";a="940130719"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 19/19 v2] Staging: xgifb: Remove useless condition.
Date: Fri,  6 Jul 2012 12:40:54 +0200
Message-Id: <4dd50a041037adf697f21a8a640779802cee835a.1341569486.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1341569486.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
 <cover.1341569486.git.magomez@igalia.com>
In-Reply-To: <cover.1341569486.git.magomez@igalia.com>
References: <cover.1341569486.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove last if branch in XGIfb_do_set_var(), as it has no action assigned.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main_26.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 0f49a21..64ffd70 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -973,8 +973,6 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 		vtotal <<= 1;
 	else if ((var->vmode & FB_VMODE_MASK) == FB_VMODE_DOUBLE)
 		vtotal <<= 2;
-	else if ((var->vmode & FB_VMODE_MASK) == FB_VMODE_INTERLACED) {
-	}
 
 	if (!htotal || !vtotal) {
 		pr_debug("Invalid 'var' information\n");
-- 
1.7.9.5

