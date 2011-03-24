Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181Ab1CXUTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:19:23 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60409 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934158Ab1CXUTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:19:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ly3vdTYwKZ7L8GVuL/FQ+DdXLy+0v7LG2y/7oY/Zel0OQFDvbPJZF6bfzQgLkCBViJ
         LRd6FKB7YetuD/i2+vuAdqhkUPcrI+3VGXFKNJGCDkDm3qdKglm1N5e5Vyx3acvn3m8K
         wCAk9Vux4ZWWFv+oM1vBFfnz6PLvQNH2liopY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC V2 12/21]drivers:video:mxsfb.c Remove extra semi-colon.
Date: Thu, 24 Mar 2011 13:18:31 -0700
Message-Id: <1300997920-31573-12-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
References: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra semi-colon from various parts 
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

