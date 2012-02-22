Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab2BVSdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:33:05 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:33927 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751065Ab2BVSdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:33:02 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18wDaFLaxcwVaozZGRCnf94vK6OxMVvQMAOBNGIDK
	6qHqaBoydgjuXC
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/5] viafb: Fix bug in centering code
Date: Wed, 22 Feb 2012 18:53:06 +0000
Message-Id: <70a27df1579b0e8d7d478d034980f8a7f8a20d54.1329936280.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1329936280.git.FlorianSchandinat@gmx.de>
References: <cover.1329936280.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Obviously this is a typo and although there were no effects observed
it's probably better to fix it.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index d35ced7..4d799c8 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1477,7 +1477,7 @@ static struct display_timing var_to_timing(const struct fb_var_screeninfo *var,
 	timing.hor_sync_end = timing.hor_sync_start + var->hsync_len;
 	timing.hor_total = timing.hor_sync_end + var->left_margin + dx;
 	timing.hor_blank_start = timing.hor_addr + dx;
-	timing.hor_blank_end = timing.hor_total - dy;
+	timing.hor_blank_end = timing.hor_total - dx;
 	timing.ver_addr = cyres;
 	timing.ver_sync_start = timing.ver_addr + var->lower_margin + dy;
 	timing.ver_sync_end = timing.ver_sync_start + var->vsync_len;
-- 
1.7.9

