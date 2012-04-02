Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab2DBOZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:25:30 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38335 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab2DBOZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 10:25:28 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: rob@ti.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]NEXT:drivers:staging:omapdrm Fix typos in drivers:omapdrm
Date: Mon,  2 Apr 2012 07:25:19 -0700
Message-Id: <1333376719-8383-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below patch fixes some typos that I found while reading. 
Note: I was told to hold off sending anything until *rc1 so hopefully 
now its alright.(wasnt sure what kernel *rc*)

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/omapdrm/omap_fb.c  |    2 +-
 drivers/staging/omapdrm/tcm-sita.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/omapdrm/omap_fb.c b/drivers/staging/omapdrm/omap_fb.c
index 04b235b..0c53a3c 100644
--- a/drivers/staging/omapdrm/omap_fb.c
+++ b/drivers/staging/omapdrm/omap_fb.c
@@ -167,7 +167,7 @@ void omap_framebuffer_update_scanout(struct drm_framebuffer *fb, int x, int y,
 }
 
 /* Call for unpin 'a' (if not NULL), and pin 'b' (if not NULL).  Although
- * buffers to unpin are just just pushed to the unpin fifo so that the
+ * buffers to unpin are just pushed to the unpin fifo so that the
  * caller can defer unpin until vblank.
  *
  * Note if this fails (ie. something went very wrong!), all buffers are
diff --git a/drivers/staging/omapdrm/tcm-sita.c b/drivers/staging/omapdrm/tcm-sita.c
index 10d5ac3..efb6095 100644
--- a/drivers/staging/omapdrm/tcm-sita.c
+++ b/drivers/staging/omapdrm/tcm-sita.c
@@ -200,7 +200,7 @@ static s32 sita_reserve_1d(struct tcm *tcm, u32 num_slots,
  *
  * @param w	width
  * @param h	height
- * @param area	pointer to the area that will be populated with the reesrved
+ * @param area	pointer to the area that will be populated with the reserved
  *		area
  *
  * @return 0 on success, non-0 error value on failure.
-- 
1.7.5.4

