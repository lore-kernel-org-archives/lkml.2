Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964823Ab2GFKpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:45:45 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:29884 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933156Ab2GFKlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:41:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAHC/9k9bdWOb/2dsb2JhbABFhWSxVIEHghkBBSMPAUYQJQImAgJXBxKID6c5kwOBII8tgRIDlTeJJoZdgmE
X-IronPort-AV: E=Sophos;i="4.77,537,1336341600"; 
   d="scan'208";a="940130679"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 04/19 v2] Staging: xgifb: Remove unused struct _chswtable.
Date: Fri,  6 Jul 2012 12:40:39 +0200
Message-Id: <85028cf763a65037d8f0b40ddf55581b79b559d2.1341569486.git.magomez@igalia.com>
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

