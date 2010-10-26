Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab0JZCpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:45:49 -0400
Received: from mail.perches.com ([173.55.12.10]:3561 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757973Ab0JZCoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:44:34 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/10] drivers/input/mouse/appletouch.c: Remove KERN_DEBUG use from dprintk
Date: Mon, 25 Oct 2010 19:44:23 -0700
Message-Id: <0f8723f18ce30ef726043555baee90d47ee995ca.1288059486.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.90.gd4c43
In-Reply-To: <cover.1288059486.git.joe@perches.com>
References: <cover.1288059486.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/input/mouse/appletouch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/mouse/appletouch.c b/drivers/input/mouse/appletouch.c
index a9cf768..b77f999 100644
--- a/drivers/input/mouse/appletouch.c
+++ b/drivers/input/mouse/appletouch.c
@@ -630,7 +630,7 @@ static void atp_complete_geyser_3_4(struct urb *urb)
 	/* Just update the base values (i.e. touchpad in untouched state) */
 	if (dev->data[dev->info->datalen - 1] & ATP_STATUS_BASE_UPDATE) {
 
-		dprintk(KERN_DEBUG "appletouch: updated base values\n");
+		dprintk("appletouch: updated base values\n");
 
 		memcpy(dev->xy_old, dev->xy_cur, sizeof(dev->xy_old));
 		goto exit;
-- 
1.7.3.dirty

