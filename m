Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934039Ab1CXTaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:30:22 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:63376 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933998Ab1CXT1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:27:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sI9rulnbs55rwdNHuiMKuFtOGbg9ULfcx6gUYxzYhhCsOaUnFwlN3OZmwibQ+q6o4O
         hSeZjMIXp97U9yNhbhqobJdHquvdukEvuj1CAJKq+KzKwd94lPf9u0PCeWKGGvhmacGl
         aJESggqY1ZyO/e9oaJTrXlZzlUK2zO8t7JWZM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 12/21]drivers:video:mxsfb.c Remove extra comma.
Date: Thu, 24 Mar 2011 12:26:50 -0700
Message-Id: <1300994819-30930-12-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
References: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra comma from various parts 
of the kernel. Please have a look when you have time, and let
me know if its legit or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/video/mxsfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
index 7d02848..0b2f2dd 100644
--- a/drivers/video/mxsfb.c
+++ b/drivers/video/mxsfb.c
@@ -401,7 +401,7 @@ static int mxsfb_set_par(struct fb_info *fb_info)
 	writel(CTRL1_FIFO_CLEAR, host->base + LCDC_CTRL1 + REG_SET);
 
 	ctrl = CTRL_BYPASS_COUNT | CTRL_MASTER |
-		CTRL_SET_BUS_WIDTH(host->ld_intf_width);;
+		CTRL_SET_BUS_WIDTH(host->ld_intf_width);
 
 	switch (fb_info->var.bits_per_pixel) {
 	case 16:
-- 
1.7.4.1

