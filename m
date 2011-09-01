Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab1IARDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 13:03:48 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54880 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab1IARDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 13:03:46 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]drivers:video:aty:radeonfb.h Fix some comments in radeonfb.h
Date: Thu,  1 Sep 2011 10:03:20 -0700
Message-Id: <1314896600-5461-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below patch, just fixes some typos/comments that I noticed allong the way.
(let me know if this is legit).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/video/aty/radeonfb.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/aty/radeonfb.h b/drivers/video/aty/radeonfb.h
index 7351e66..9f9daf0 100644
--- a/drivers/video/aty/radeonfb.h
+++ b/drivers/video/aty/radeonfb.h
@@ -147,7 +147,7 @@ struct pll_info {
  * This structure contains the various registers manipulated by this
  * driver for setting or restoring a mode. It's mostly copied from
  * XFree's RADEONSaveRec structure. A few chip settings might still be
- * tweaked without beeing reflected or saved in these registers though
+ * tweaked without being reflected or saved in these registers though
  */
 struct radeon_regs {
 	/* Common registers */
@@ -372,7 +372,7 @@ struct radeonfb_info {
  */
 
 /* Note about this function: we have some rare cases where we must not schedule,
- * this typically happen with our special "wake up early" hook which allows us to
+ * this typically happens with our special "wake up early" hook which allows us to
  * wake up the graphic chip (and thus get the console back) before everything else
  * on some machines that support that mechanism. At this point, interrupts are off
  * and scheduling is not permitted
@@ -410,7 +410,7 @@ static inline void _OUTREGP(struct radeonfb_info *rinfo, u32 addr,
 #define OUTREGP(addr,val,mask)	_OUTREGP(rinfo, addr, val,mask)
 
 /*
- * Note about PLL register accesses:
+ * Note about PLL register access:
  *
  * I have removed the spinlock on them on purpose. The driver now
  * expects that it will only manipulate the PLL registers in normal
-- 
1.7.6

