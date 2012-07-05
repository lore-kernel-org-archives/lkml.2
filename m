Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab2GEPUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:20:49 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:55657 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933263Ab2GEPUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:20:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAJGv9U9bdWOb/2dsb2JhbABFhV+xSIEHghkBBSMPAUYQJQImAgJXBxKID6Z1klKBII9FgRIDlTeJJoZdgmE
X-IronPort-AV: E=Sophos;i="4.77,531,1336341600"; 
   d="scan'208";a="939596352"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 04/19] Staging: xgifb: Remove unused struct _chswtable.
Date: Thu,  5 Jul 2012 16:45:47 +0200
Message-Id: <104a4d1258e94379fc4d661e5a5c8bec3b3b89b2.1341498465.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1341498465.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
In-Reply-To: <cover.1341498465.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Struct _chswtable and the variable mychswtable are not used anywhere, so remove
them.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main.h |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index 1686c5a..c033da4 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -227,16 +227,6 @@ static const struct _XGI_vrate {
 	{0, 0, 0, 0}
 };
 
-static const struct _chswtable {
-	int subsysVendor;
-	int subsysCard;
-	char *vendorName;
-	char *cardName;
-} mychswtable[] = {
-	{ 0x1631, 0x1002, "Mitachi", "0x1002" },
-	{ 0,      0,      ""       , ""       }
-};
-
 static const struct _XGI_TV_filter {
 	u8 filter[9][4];
 } XGI_TV_filter[] = {
-- 
1.7.9.5

