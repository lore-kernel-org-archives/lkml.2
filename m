Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab0DZFrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 01:47:40 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46679 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab0DZFri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 01:47:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ThNsv5hUsghx/Z/6/Nwz32SptB9H/QG9WhGheYviN2AtjZ+kg3RQXLs6j/SPLn84JG
         lHD+f097ybSxn04DWehTdSqcadI2bLJTzyKe3809xowHof8dmryKhsGklWD34WggT8mx
         KA3HS5E0Xtt77COHeETjHzh7lBtidISYoshRI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]trivial:Fix some comments.
Date: Sun, 25 Apr 2010 22:47:22 -0700
Message-Id: <1272260842-2592-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some comments.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
---
 drivers/gpu/drm/nouveau/nv50_display.c |    2 +-
 drivers/s390/block/dasd_eckd.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nv50_display.c b/drivers/gpu/drm/nouveau/nv50_display.c
index 649db4c..452ed31 100644
--- a/drivers/gpu/drm/nouveau/nv50_display.c
+++ b/drivers/gpu/drm/nouveau/nv50_display.c
@@ -239,7 +239,7 @@ nv50_display_init(struct drm_device *dev)
 	nv_wr32(dev, NV50_PDISPLAY_UNK_388, 0x150000);
 	nv_wr32(dev, NV50_PDISPLAY_UNK_38C, 0);
 
-	/* The precise purpose is unknown, i suspect it has something to do
+	/* The precise purpose is unknown, I suspect it has something to do
 	 * with text mode.
 	 */
 	if (nv_rd32(dev, NV50_PDISPLAY_INTR_1) & 0x100) {
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 0cb2331..582c568 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2291,7 +2291,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 	} else
 		return ERR_PTR(-EINVAL);
 
-	/* trackbased I/O needs address all memory via TIDAWs,
+	/* trackbased I/O needs to address all memory via TIDAWs,
 	 * not just for 64 bit addresses. This allows us to map
 	 * each segment directly to one tidaw.
 	 */
-- 
1.6.5.GIT

