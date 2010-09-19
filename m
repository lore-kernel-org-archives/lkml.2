Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab0ISJ3B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 05:29:01 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:58107 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab0ISJ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 05:28:48 -0400
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Lars Lindley <lindley@coyote.org>, Pavel Machek <pavel@ucw.cz>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: [PATCH 7/7] w35und: Remove unused fields from struct wbsoft_priv
Date: Sun, 19 Sep 2010 12:28:43 +0300
Message-Id: <1284888523-9625-7-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1284888523-9625-6-git-send-email-penberg@kernel.org>
References: <1284888523-9625-1-git-send-email-penberg@kernel.org>
 <1284888523-9625-2-git-send-email-penberg@kernel.org>
 <1284888523-9625-3-git-send-email-penberg@kernel.org>
 <1284888523-9625-4-git-send-email-penberg@kernel.org>
 <1284888523-9625-5-git-send-email-penberg@kernel.org>
 <1284888523-9625-6-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes unused fields from "struct wbsoft_priv".

Cc: Lars Lindley <lindley@coyote.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Ruslan Pisarev <ruslan@rpisarev.org.ua>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/core.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/winbond/core.h b/drivers/staging/winbond/core.h
index 333b197..2b87a00 100644
--- a/drivers/staging/winbond/core.h
+++ b/drivers/staging/winbond/core.h
@@ -42,9 +42,6 @@ struct mlme_frame {
 #define WB_MAX_LINK_NAME_LEN 40
 
 struct wbsoft_priv {
-	u32 adapterIndex;	/* 20060703.4 Add for using padapterContext
-							global adapter point */
-
 	struct wb_local_para sLocalPara;	/* Myself connected
 							parameters */
 
@@ -59,10 +56,6 @@ struct wbsoft_priv {
 	u32 RxByteCount;
 	u32 TxByteCount;
 
-	struct sk_buff *packet_return;
-	s32 netif_state_stop;	/* 1: stop  0: normal */
-	struct iw_statistics iw_stats;
-
 	u8 LinkName[WB_MAX_LINK_NAME_LEN];
 
 	bool enabled;
-- 
1.6.3.3

